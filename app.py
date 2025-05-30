from flask import Flask, jsonify
import os

app = Flask(__name__)

@app.route('/')
def index():
    return "Welcome to my Flask app! 🚀"

@app.route('/health')
def health():
    response = jsonify({"status": "healthy"})
    response.headers["Content-Type"] = "application/json"
    return response

@app.route('/version')
def version():
    app_version = os.getenv("APP_VERSION", "0.0.1")
    return f"Application Version: {app_version}"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)

