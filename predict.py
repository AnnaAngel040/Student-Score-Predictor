import pandas as pd
import pickle

with open("student_model.pkl", "rb") as file:
    model = pickle.load(file)

hours = float(input("Hours studied per week: "))
attendance = float(input("Attendance (%): "))

gender = input("Gender (Male/Female): ")
tutoring = input("Tutoring (Yes/No): ")
region = input("Region (Urban/Rural): ")

gender_male = 1 if gender.lower() == "male" else 0
tutoring_yes = 1 if tutoring.lower() == "yes" else 0
region_urban = 1 if region.lower() == "urban" else 0

student = pd.DataFrame({
    "HoursStudied/Week": [hours],
    "Attendance(%)": [attendance],
    "Gender_Male": [gender_male],
    "Tutoring_Yes": [tutoring_yes],
    "Region_Urban": [region_urban]
})

prediction = model.predict(student)

print(f"\nPredicted Score: {prediction[0]:.2f}")