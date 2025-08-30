from sklearn.pipeline import Pipeline
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression
from joblib import dump
import os

DATA = [
    # love
    ("i love this", "love"), ("love docker", "love"), ("this is amazing", "love"),
    ("amo esto", "love"), ("me encanta", "love"), ("qué belleza", "love"),
    ("qué felicidad", "happy"), ("i am so happy", "happy"), ("estoy feliz", "happy"),
    ("hoy es un gran día", "happy"), ("awesome day", "happy"), ("todo genial", "happy"),
    ("odio esto", "angry"), ("i hate bugs", "angry"), ("so angry with this", "angry"),
    ("this is terrible", "angry"), ("qué rabia", "angry"), ("estoy furiosa", "angry"),
    ("me duermo", "sleepy"), ("i am sleepy", "sleepy"), ("so tired", "sleepy"),
    ("need a nap", "sleepy"), ("tengo sueño", "sleepy"), ("estoy cansada", "sleepy"),
    ("hello robot", "robot"), ("ai models rock", "robot"), ("docker containers", "robot"),
    ("amo la inteligencia artificial", "robot"), ("vamos a programar", "robot"), ("hola mundo", "robot"),
    ("party time!", "party"), ("es hora de fiesta", "party"), ("vamos a celebrar", "party"),
    ("fiesta hoy", "party"), ("let's party", "party"), ("celebration mode", "party"),
    ("estoy triste hoy", "sad"), ("i am sad", "sad"), ("so sad", "sad"), ("no tengo ganas", "sad"),
    ("me siento mal", "sad"), ("bad day", "sad"),
    ("need to focus, hello robot", "nerd"), ("i love math", "nerd"), ("soy nerd", "nerd"),
    ("estudiando código", "nerd"), ("focus mode", "nerd"), ("leyendo documentación", "nerd"),
    ("amo docker y los modelos", "docker"), ("docker es genial", "docker"), ("me gusta docker", "docker"),
    ("run docker compose", "docker"), ("contenedores everywhere", "docker"), ("🐳", "docker"),
]

X = [t for t, _ in DATA]
y = [c for _, c in DATA]

pipeline = Pipeline(steps=[
    ("tfidf", TfidfVectorizer(lowercase=True, ngram_range=(1,2), min_df=1)),
    ("clf", LogisticRegression(max_iter=400))
])
pipeline.fit(X, y)

os.makedirs("artifacts", exist_ok=True)
dump(pipeline, "artifacts/emoji_pipeline.joblib")

EMOJI_MAP = {
    "love": "😍",
    "angry": "😡",
    "sleepy": "😴",
    "robot": "🤖",
    "happy": "😃",
    "sad": "😢",
    "party": "🥳",
    "nerd": "🤓",
    "docker": "🐳",
}
dump(EMOJI_MAP, "artifacts/emoji_map.joblib")
print("Modelo de emojis entrenado y guardado en artifacts/")
