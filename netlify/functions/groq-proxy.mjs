// Intermediario entre el asistente de la plataforma (_footer.html) y la API de
// Groq. La clave se lee de la variable de entorno GROQ_API_KEY definida en
// Netlify (Site configuration > Environment variables, alcance "Functions"),
// de modo que nunca llega al navegador.
//
// El modelo y los límites se fijan aquí y no en el navegador, para que la
// función no pueda usarse como acceso abierto a la API.

const MODELO = Netlify.env.get("GROQ_MODEL") || "llama-3.3-70b-versatile";
const MAX_TOKENS = 900;
const MAX_MENSAJES = 12;        // turnos de conversación que se reenvían
const MAX_CARACTERES = 2000;    // por mensaje

const json = (obj, status) =>
  new Response(JSON.stringify(obj), {
    status,
    headers: { "Content-Type": "application/json" }
  });

export default async (request) => {
  if (request.method !== "POST") return json({ error: "Método no permitido" }, 405);

  const clave = Netlify.env.get("GROQ_API_KEY");
  if (!clave) return json({ error: "Falta la variable GROQ_API_KEY en Netlify" }, 500);

  let entrada;
  try {
    entrada = await request.json();
  } catch {
    return json({ error: "Solicitud no válida" }, 400);
  }

  const sistema = typeof entrada.system === "string" ? entrada.system.slice(0, 4000) : "";
  const mensajes = (Array.isArray(entrada.messages) ? entrada.messages : [])
    .filter(m => (m.role === "user" || m.role === "assistant") && typeof m.content === "string")
    .slice(-MAX_MENSAJES)
    .map(m => ({ role: m.role, content: m.content.slice(0, MAX_CARACTERES) }));

  if (mensajes.length === 0) return json({ error: "Mensaje vacío" }, 400);

  try {
    const r = await fetch("https://api.groq.com/openai/v1/chat/completions", {
      method: "POST",
      headers: {
        "Authorization": `Bearer ${clave}`,
        "Content-Type": "application/json"
      },
      body: JSON.stringify({
        model: MODELO,
        messages: [{ role: "system", content: sistema }, ...mensajes],
        temperature: 0.3,
        max_tokens: MAX_TOKENS
      })
    });
    const datos = await r.json();
    if (!r.ok) {
      return json({ error: datos?.error?.message || `Groq respondió ${r.status}` }, r.status);
    }
    const texto = datos?.choices?.[0]?.message?.content;
    if (!texto) return json({ error: "Respuesta vacía del modelo" }, 502);
    return json({ respuesta: texto, modelo: MODELO }, 200);
  } catch (e) {
    return json({ error: "No se pudo contactar con Groq" }, 502);
  }
};
