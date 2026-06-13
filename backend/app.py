from flask import Flask, request, jsonify
import pandas as pd
import pickle
from flask_cors import CORS
import os
import pickle

model_path = os.path.join(
    os.path.dirname(__file__),
    "..",
    "student_model.pkl"
)

app = Flask(__name__)
CORS(app)

with open(model_path, "rb") as file:
    model = pickle.load(file)

@app.route("/test")
def test():
    return jsonify({"message": "working"})

@app.route("/")
def home():
    return "Student Score Predictor API is running!"

@app.route("/predict", methods=["POST"])
def predict():

    data = request.json

    student = pd.DataFrame({
        "HoursStudied/Week": [data["hours"]],
        "Attendance(%)": [data["attendance"]],
        "Gender_Male": [1 if data["gender"] == "Male" else 0],
        "Tutoring_Yes": [1 if data["tutoring"] == "Yes" else 0],
        "Region_Urban": [1 if data["region"] == "Urban" else 0]
    })

    prediction = model.predict(student)

    return jsonify({
        "predicted_score": round(float(prediction[0]), 2)
    })

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))
    app.run(host="0.0.0.0", port=port)