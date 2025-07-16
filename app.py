from flask import Flask
import os

app = Flask(__name__)

@app.route('/')
def hello():
    return {"message": "IA Humanizer Service is running!", "status": "ok"}

@app.route('/health')
def health():
    return {"status": "healthy"}

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 8080))
    app.run(host='0.0.0.0', port=port, debug=False) 