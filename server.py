from flask import Flask, request, jsonify
import os
import subprocess
import threading
import time

app = Flask(__name__)

# Variable globale pour suivre l'état de l'entraînement
training_status = {"running": False, "completed": False, "error": None}

@app.route('/')
def home():
    return jsonify({
        "message": "IA Humanizer Training Service",
        "status": "running",
        "endpoints": {
            "start_training": "/start-training",
            "status": "/status",
            "health": "/health"
        }
    })

@app.route('/health')
def health():
    return jsonify({"status": "healthy"})

@app.route('/start-training')
def start_training():
    global training_status
    
    if training_status["running"]:
        return jsonify({"error": "Training already in progress"}), 400
    
    training_status = {"running": True, "completed": False, "error": None}
    
    def run_training():
        global training_status
        try:
            # Lancer l'entraînement
            result = subprocess.run(
                ["python", "train_on_gcp.py"],
                capture_output=True,
                text=True,
                timeout=3600  # 1 heure max
            )
            
            if result.returncode == 0:
                training_status = {"running": False, "completed": True, "error": None}
            else:
                training_status = {"running": False, "completed": False, "error": result.stderr}
                
        except Exception as e:
            training_status = {"running": False, "completed": False, "error": str(e)}
    
    # Lancer l'entraînement en arrière-plan
    thread = threading.Thread(target=run_training)
    thread.start()
    
    return jsonify({
        "message": "Training started",
        "status": "started"
    })

@app.route('/status')
def get_status():
    return jsonify(training_status)

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 8080))
    app.run(host='0.0.0.0', port=port, debug=False) 