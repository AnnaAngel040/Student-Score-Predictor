import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv("SAP-4000.csv")

df = df.drop(columns=["Parent Education"])

plt.scatter(df["HoursStudied/Week"], df["Exam_Score"])
plt.xlabel("Hours Studied per Week")
plt.ylabel("Exam Score")
plt.title("Hours Studied vs Exam Score")

plt.show()
plt.figure()

plt.scatter(df["Attendance(%)"], df["Exam_Score"])

plt.xlabel("Attendance (%)")
plt.ylabel("Exam Score")
plt.title("Attendance vs Exam Score")

plt.show()
print(df.groupby("Tutoring")["Exam_Score"].mean())
print(df.groupby("Gender")["Exam_Score"].mean())
print()
print(df.groupby("Region")["Exam_Score"].mean())