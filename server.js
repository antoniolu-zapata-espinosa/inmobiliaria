const express = require('express');
const cors = require('cors');
require('dotenv').config();

const app = express();
app.use(express.json());
app.use(cors()); // Permite peticiones desde tu sitio web

const PORT = process.env.PORT || 3000;

app.post('/api/chat', async (req, res) => {
    try {
        const { message } = req.body;

        // Petición a OpenRouter usando un modelo gratuito (ej. un modelo de Llama o el router libre)
        const response = await fetch("https://openrouter.ai/api/v1/chat/completions", {
            method: "POST",
            headers: {
                "Authorization": `Bearer ${process.env.OPENROUTER_API_KEY}`,
                "HTTP-Referer": "https://tusitio.com", // Opcional, para rankings de OpenRouter
                "X-Title": "Mi Web Chatbot",           // Opcional
                "Content-Type": "application/json"
            },
            body: JSON.stringify({
                "model": "openrouter/free", // Selecciona automáticamente un modelo gratuito disponible
                "messages": [
                    {
                        "role": "system",
                        "content": "Eres un asistente virtual amable para un sitio web de servicios. Responde de forma breve y concisa."
                    },
                    {
                        "role": "user",
                        "content": message
                    }
                ]
            })
        });

        const data = await response.json();
        
        if (!response.ok) {
            throw new Error(data.error?.message || "Error al comunicarse con OpenRouter");
        }

        const reply = data.choices[0].message.content;
        res.json({ reply });

    } catch (error) {
        console.error(error);
        res.status(500).json({ error: "Hubo un error procesando tu mensaje." });
    }
});

app.listen(PORT, () => {
    console.log(`Servidor corriendo en el puerto ${PORT}`);
});