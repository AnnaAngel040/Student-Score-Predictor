import pandas as pd

from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
from sklearn.metrics import r2_score

# Load data
df = pd.read_csv("SAP-4000.csv")

# Drop unwanted column
df = df.drop(columns=["Parent Education"])

# Convert categorical columns to numbers
df = pd.get_dummies(
    df,
    columns=["Gender", "Tutoring", "Region"],
    drop_first=True
)

# Features and target
X = df.drop(columns=["Exam_Score"])
y = df["Exam_Score"]

# Split data
X_train, X_test, y_train, y_test = train_test_split(
    X,
    y,
    test_size=0.2,
    random_state=42
)

# Train model
model = LinearRegression()
model.fit(X_train, y_train)

# Predict
predictions = model.predict(X_test)

# Evaluate
print("R2 Score:", r2_score(y_test, predictions))
print(X.columns)
hours = float(input("Hours studied per week: "))
attendance = float(input("Attendance (%): "))

gender = input("Gender (Male/Female): ")
tutoring = input("Tutoring (Yes/No): ")
region = input("Region (Urban/Rural): ")

gender_male = 1 if gender.lower() == "male" else 0
tutoring_yes = 1 if tutoring.lower() == "yes" else 0
region_urban = 1 if region.lower() == "urban" else 0

student = [[
    hours,
    attendance,
    gender_male,
    tutoring_yes,
    region_urban
]]

predicted_score = model.predict(student)

print(f"\nPredicted Exam Score: {predicted_score[0]:.2f}")