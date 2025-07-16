FROM python:3.11
WORKDIR /app
COPY ./app.py ./app.py
COPY ../model/humanizer_model ./humanizer_model
RUN pip install fastapi uvicorn transformers torch
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"] 