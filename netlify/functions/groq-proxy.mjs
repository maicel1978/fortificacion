export default async (request) => {
  const GROQ_API_KEY = Netlify.env.get("GROQ_API_KEY");

  if (!GROQ_API_KEY) {
    return new Response(
      JSON.stringify({ error: "API key not configured on Netlify" }),
      { status: 500, headers: { "Content-Type": "application/json" } }
    );
  }

  try {
    const body = await request.json();

    const groqResponse = await fetch("https://api.groq.com/openai/v1/chat/completions", {
      method: "POST",
      headers: {
        "Authorization": `Bearer ${GROQ_API_KEY}`,
        "Content-Type": "application/json"
      },
      body: JSON.stringify(body)
    });

    const data = await groqResponse.json();

    return new Response(JSON.stringify(data), {
      status: groqResponse.status,
      headers: { "Content-Type": "application/json" }
    });

  } catch (error) {
    return new Response(
      JSON.stringify({ error: "Error en la solicitud a Groq" }),
      { status: 500, headers: { "Content-Type": "application/json" } }
    );
  }
};