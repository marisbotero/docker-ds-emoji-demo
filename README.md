# Docker DS Emoji Demo 🐳✨

**Objetivo:** ¡Demostrar de forma divertida cómo combinar **Python (FastAPI + ML)** y **R Shiny** en un stack reproducible con **Docker Compose**!  
Un solo `docker compose up --build` y tienes un flujo de trabajo Data Science listo para sorprender.

## 🚀 Requisitos
- Docker Desktop (Windows/Mac) o Docker en Linux.
- (Opcional) WSL2 en Windows para mejor rendimiento.

## ▶️ Cómo correr
```bash
docker compose up --build
```
- FastAPI (Python): **http://localhost:8000/docs** (Swagger UI)
- Shiny (R): **http://localhost:3838** (dashboard interactivo)

> Cambia el código en `python-app/` o `r-shiny/` y verás hot-reload automático gracias a los volúmenes montados.

## 🧠 ¿Qué hace el modelo?
Un clasificador de emociones mini entrenado offline (ES/EN).  
Convierte frases en una de **9 clases**:

| Clase    | Emoji | Ejemplo frase (ES/EN)         |
|----------|-------|------------------------------|
| love     | 😍    | "me encanta", "i love this"  |
| happy    | 😃    | "qué felicidad!", "awesome day"|
| angry    | 😡    | "odio esto", "i hate bugs"    |
| sleepy   | 😴    | "me duermo", "need a nap"     |
| robot    | 🤖    | "hello robot", "ai models rock"|
| party    | 🥳    | "fiesta hoy", "party time!"   |
| sad      | 😢    | "estoy triste", "i am sad"    |
| nerd     | 🤓    | "focus mode", "i love math"   |
| docker   | 🐳    | "amo docker", "run docker compose"|

- Entrenado en build-time, reproducible y sin dependencias externas.
- El endpoint `/predict` devuelve la predicción principal, alternativas ordenadas (todas las clases con probabilidad) y un mensaje motivacional.

## 📦 Ejemplo de respuesta `/predict`
```json
{
  "prediction": { "label": "docker", "emoji": "🐳", "confidence": 0.82 },
  "alternatives": [
    {"label": "docker", "emoji": "🐳", "confidence": 0.82},
    {"label": "love", "emoji": "😍", "confidence": 0.12},
    ...
  ],
  "message": "¡Todo es mejor en contenedores! / Everything is better in containers!"
}
```

## 🧪 Frases para probar
- "amo docker y los modelos" → `docker 🐳` o `love 😍`
- "odio los bugs" → `angry 😡`
- "me duermo" → `sleepy 😴`
- "party time!" → `party 🥳`
- "need to focus, hello robot" → `robot 🤖` o `nerd 🤓`
- "estoy triste hoy" → `sad 😢`
- "qué felicidad!" → `happy 😃`

## 🧩 ¿Por qué esto le encanta a un Data Scientist?
- **Portabilidad:** corre igual en Mac, Windows o Linux.
- **Reproducibilidad:** todo versionado en imágenes y `compose.yml`.
- **Velocidad:** del “hola mundo” a dashboard ML en **minutos**.
- **Integración real:** Python y R colaborando, ¡sin dolor!
- **UI wow:** dashboard visual, selector ES/EN, emojis grandes y gráficas cool.

## 🛠️ Estructura
```
docker-ds-emoji-demo/
├─ docker-compose.yml
├─ python-app/       # API de predicción (FastAPI)
└─ r-shiny/          # Dashboard Shiny
```

## ✨ Maris vibes
- Shiny muestra el emoji grande con fade-in 🎉
- README con emojis y copy friendly
- Código limpio, educativo y divertido

¡Listo para demos, workshops y sorprender a tu equipo! 💫

## 🧩 Por qué esto le encanta a un Data Scientist
- **Portabilidad:** funciona igual en Mac/Windows/Linux.
- **Reproducibilidad:** todo definido en imágenes y `compose.yml`.
- **Velocidad:** del “hola mundo” al dashboard en **minutos**.

## 🛠️ Estructura
```
docker-ds-emoji-demo/
├─ docker-compose.yml
├─ python-app/       # API de predicción (FastAPI)
└─ r-shiny/          # Dashboard Shiny
```

## ✨ Maris vibes
- Shiny muestra el emoji grande 🤩
- README con emojis y copy friendly
- Código limpio y educativo

¡Listo para demos y workshops! 💫
