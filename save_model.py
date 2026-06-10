import pandas as pd
import pickle

from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression

df = pd.read_csv("SAP-4000.csv")

df = df.drop(columns=["Parent Education"])

df = pd.get_dummies(
    df,
    columns=["Gender", "Tutoring", "Region"],
    drop_first=True
)

X = df.drop(columns=["Exam_Score"])
y = df["Exam_Score"]

X_train, X_test, y_train, y_test = train_test_split(
    X,
    y,
    test_size=0.2,
    random_state=42
)

model = LinearRegression()
model.fit(X_train, y_train)

with open("student_model.pkl", "wb") as file:
    pickle.dump(model, file)

print("Model saved successfully!")