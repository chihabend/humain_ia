from fastapi import FastAPI, Request
from transformers import AutoTokenizer, AutoModelForSeq2SeqLM
import torch

app = FastAPI()
tokenizer = AutoTokenizer.from_pretrained("../model/humanizer_model")
model = AutoModelForSeq2SeqLM.from_pretrained("../model/humanizer_model")

@app.post("/humanize")
async def humanize(request: Request):
    data = await request.json()
    text = data["text"]
    inputs = tokenizer(text, return_tensors="pt", truncation=True, padding=True, max_length=128)
    with torch.no_grad():
        outputs = model.generate(**inputs, max_length=128)
    result = tokenizer.decode(outputs[0], skip_special_tokens=True)
    return {"humanized": result} 