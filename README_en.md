# Docker DS Emoji Demo 🐳✨

**Goal:** Show, in a simple and cool way, how to combine **Python (FastAPI + ML emoji model)** with **R Shiny (dashboard)** using **Docker Compose**.
Just run `docker compose up` and boom! → a reproducible stack on any machine.

## 🚀 Requirements
- Docker Desktop (Windows/Mac) or Docker on Linux.
- (Optional) WSL2 enabled on Windows for better performance.

## ▶️ How to run
```bash
docker compose up --build
```
- FastAPI (Python): **http://localhost:8000/docs**
- Shiny (R): **http://localhost:3838**

> If you edit files in `python-app/` or `r-shiny/`, changes are reflected instantly thanks to mounted volumes.

## 🧠 What does the model do?
A mini classifier that maps text → categories (love 😍, angry 😡, sleepy 😴, robot 🤖). 
It is trained at build-time with a small (ES/EN) dataset for 100% reproducibility and offline use.

## 🧩 Why Data Scientists love this
- **Portability:** works the same on Mac/Windows/Linux.
- **Reproducibility:** everything defined in images and `compose.yml`.
- **Speed:** from “hello world” to dashboard in **minutes**.

## 🛠️ Structure
```
docker-ds-emoji-demo/
├─ docker-compose.yml
├─ python-app/       # Prediction API (FastAPI)
└─ r-shiny/          # Shiny Dashboard
```

## ✨ Fun vibes
- Shiny shows the emoji big and proud 🤩
- README with emojis and friendly copy
- Clean, educational code

Ready for demos and workshops! 💫
