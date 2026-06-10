from flask import Flask, request, jsonify
import pandas as pd
import pickle
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

with open("student_model.pkl", "rb") as file:
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
    app.run(debug=True)