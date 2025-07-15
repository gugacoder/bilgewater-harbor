FROM python:3.9-slim

WORKDIR /app

RUN pip install fastapi uvicorn sentence-transformers

COPY <<EOF app.py
from fastapi import FastAPI
from fastapi.responses import HTMLResponse
from sentence_transformers import SentenceTransformer
from pydantic import BaseModel
from typing import Union, List

app = FastAPI()
model = SentenceTransformer('sentence-transformers/all-MiniLM-L6-v2')

class EmbeddingRequest(BaseModel):
    text: Union[str, List[str]]

@app.get("/", response_class=HTMLResponse)
async def root():
    return """
    <!DOCTYPE html>
    <html>
    <head>
        <title>Embeddings API - CodrStudio</title>
        <style>
            * { margin: 0; padding: 0; box-sizing: border-box; }
            body {
                font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
                background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                color: #fff;
            }
            .container {
                background: rgba(255, 255, 255, 0.1);
                backdrop-filter: blur(10px);
                border-radius: 20px;
                padding: 40px;
                max-width: 800px;
                width: 90%;
                box-shadow: 0 20px 40px rgba(0, 0, 0, 0.2);
                border: 1px solid rgba(255, 255, 255, 0.2);
            }
            h1 {
                font-size: 2.5em;
                margin-bottom: 10px;
                background: linear-gradient(45deg, #fff, #e0e0e0);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
            }
            .subtitle {
                color: #b8c5d6;
                margin-bottom: 30px;
                font-size: 1.1em;
            }
            .endpoint {
                background: rgba(0, 0, 0, 0.2);
                border-radius: 10px;
                padding: 20px;
                margin-bottom: 20px;
                border: 1px solid rgba(255, 255, 255, 0.1);
            }
            .method {
                display: inline-block;
                padding: 4px 12px;
                border-radius: 4px;
                font-weight: bold;
                font-size: 0.9em;
                margin-right: 10px;
            }
            .post { background: #49cc90; color: #000; }
            .get { background: #61affe; color: #000; }
            .path {
                font-family: 'Courier New', monospace;
                font-size: 1.1em;
                margin-top: 10px;
                word-break: break-all;
            }
            .description {
                margin-top: 10px;
                color: #d1dae5;
                line-height: 1.6;
            }
            .example {
                background: rgba(0, 0, 0, 0.3);
                border-radius: 8px;
                padding: 15px;
                margin-top: 15px;
                font-family: 'Courier New', monospace;
                font-size: 0.9em;
                overflow-x: auto;
            }
            .footer {
                margin-top: 30px;
                text-align: center;
                color: #8b9dc3;
                font-size: 0.9em;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>Embeddings API</h1>
            <p class="subtitle">Sentence Transformers MiniLM-L6-v2</p>
            
            <div class="endpoint">
                <span class="method post">POST</span>
                <div class="path">/api/1/embeddings/minilm-l6-v2</div>
                <div class="description">
                    Gera embeddings de 384 dimensões para texto usando o modelo all-MiniLM-L6-v2.
                    Aceita uma string única ou array de strings.
                </div>
                <div class="example">
{
  "text": "Como resetar minha senha?"
}
                </div>
            </div>
            
            <div class="endpoint">
                <span class="method get">GET</span>
                <div class="path">/health</div>
                <div class="description">
                    Verifica o status da API e confirma o modelo carregado.
                </div>
            </div>
            
            <div class="footer">
                <p>CodrStudio API Services</p>
                <p>Modelo: sentence-transformers/all-MiniLM-L6-v2 | Dimensões: 384</p>
            </div>
        </div>
    </body>
    </html>
    """

@app.post("/api/1/embeddings/minilm-l6-v2")
async def generate_embeddings(request: EmbeddingRequest):
    texts = request.text if isinstance(request.text, list) else [request.text]
    embeddings = model.encode(texts)
    return {"embeddings": embeddings.tolist()}

@app.get("/health")
async def health():
    return {"status": "ok", "model": "all-MiniLM-L6-v2"}
EOF

CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "80"]
