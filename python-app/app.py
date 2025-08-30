from fastapi import FastAPI
from pydantic import BaseModel, Field
from joblib import load
import os
from typing import Dict, List

app = FastAPI(title="Emoji Classifier API", description="Text -> Emoji 🤖😍😡😴", version="1.0.0")

PIPE_PATH = "artifacts/emoji_pipeline.joblib"
MAP_PATH = "artifacts/emoji_map.joblib"

def ensure_model():
    if not (os.path.exists(PIPE_PATH) and os.path.exists(MAP_PATH)):
        import train
    pipe = load(PIPE_PATH)
    emoji_map: Dict[str, str] = load(MAP_PATH)
    return pipe, emoji_map

PIPELINE, EMOJI_MAP = ensure_model()

class TextIn(BaseModel):
    """Input text for prediction."""
    text: str = Field(..., example="amo docker y los modelos")

class AlternativeOut(BaseModel):
    label: str
    emoji: str
    confidence: float

class PredictionOut(BaseModel):
    prediction: AlternativeOut
    alternatives: List[AlternativeOut]
    message: str

@app.get("/health")
def health():
    return {"status": "ok"}

@app.post("/predict", response_model=PredictionOut, summary="Predict the emoji and emotion from text", response_description="Prediction and alternatives with motivational message")
def predict(inp: TextIn):
    txt = inp.text.strip()
    if not txt:
        return PredictionOut(
            prediction=AlternativeOut(label=None, emoji=None, confidence=0.0),
            alternatives=[],
            message="Por favor, escribe un mensaje para analizar. / Please enter a message."
        )
    if hasattr(PIPELINE.named_steps["clf"], "predict_proba"):
        proba = PIPELINE.predict_proba([txt])[0]
        classes = PIPELINE.named_steps["clf"].classes_
        alternatives = [
            AlternativeOut(
                label=str(lbl),
                emoji=EMOJI_MAP.get(lbl, "❓"),
                confidence=round(float(p), 3)
            ) for lbl, p in zip(classes, proba)
        ]
        alternatives = sorted(alternatives, key=lambda x: x.confidence, reverse=True)
        pred = alternatives[0]
    else:
        label = PIPELINE.predict([txt])[0]
        pred = AlternativeOut(label=label, emoji=EMOJI_MAP.get(label, "❓"), confidence=0.75)
        alternatives = [pred]

    MOTIVATIONAL = {
        "love": "¡Comparte el amor! / Spread the love!",
        "angry": "Respira hondo, todo mejora. / Take a breath, things get better.",
        "sleepy": "Tómate un break, ¡te lo ganaste! / Take a break, you earned it!",
        "robot": "¡Modo robot ON! / Robot mode: ON!",
        "happy": "Sigue sonriendo, ¡es contagioso! / Keep smiling, it's contagious!",
        "sad": "Ánimo, todo pasa. / Cheer up, this too shall pass.",
        "party": "¡A celebrar! / Let's party!",
        "nerd": "El conocimiento es poder. / Knowledge is power.",
        "docker": "¡Todo es mejor en contenedores! / Everything is better in containers!",
    }
    msg = MOTIVATIONAL.get(pred.label or "", "¡Sigue explorando emociones! / Keep exploring emotions!")
    return PredictionOut(
        prediction=pred,
        alternatives=alternatives,
        message=msg
    )
