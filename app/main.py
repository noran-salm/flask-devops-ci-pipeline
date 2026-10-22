import os
from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/')
def index():
    return jsonify({"message": "Welcome to the app!"}), 200

@app.route('/health')
def health_check():
    if os.getenv('FAIL_HEALTH', 'false').lower() == 'true':
        return jsonify({"status": "unhealthy", "error": "Database connection lost"}), 500
    
    return jsonify({"status": "healthy"}), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)