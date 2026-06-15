# Student Score Predictor 🎓

An end-to-end Machine Learning web dashboard application that predicts a student's final academic score based on their weekly study habits, attendance record, and demographic factors. 

https://student-score-predictor-2026.web.app/

---

## 📊 Dataset & Features

The model is trained on the **`SAP-4000.csv`** dataset, mapping various student metrics against their final performance scores.

### Target Feature & Predictors
| Feature | Type | Status | Description |
| :--- | :--- | :--- | :--- |
| **HoursStudied/Week** | Numerical | Retained | Total active self-study hours per week |
| **Attendance(%)** | Numerical | Retained | Academic attendance percentage |
| **Gender** | Categorical | Retained | Male / Female identity |
| **Tutoring** | Categorical | Retained | Private tutoring enrollment (Yes/No) |
| **Region** | Categorical | Retained | Geographic location status (Urban/Rural) |


---

## 🔍 Exploratory Data Analysis (EDA) Insights

During data preprocessing and visualization, several crucial behavioral patterns emerged:
* **The Tutoring Boost 🚀:** Enrollment in private tutoring programs shows a powerful, statistically significant upward shift in student scores.
* **Study Commitment 📚:** Weekly hours studied correlates heavily with performance, acting as one of the strongest positive predictors in our model.
* **Demographic Neutrality ⚖️:** Gender identity exhibits minimal to no real effect on final performance outcomes.
* **Geographic Baseline 🏙️:** Regional differences (Urban vs. Rural) present a very small impact on predicting scores, though urban centers show a slight variance buffer due to resource distribution.

---

## 🤖 The Machine Learning Model

We implemented a core **Linear Regression** algorithm optimized for deployment speed and continuous inference testing.

* **Performance Metric:** $$R^2 = 0.9087$$
* **Artifact:** The trained model pipeline is fully serialized and deployed as `student_model.pkl`.

> **Note:** An $R^2$ score above 90% proves that our selected behavioral attributes successfully capture the vast majority of variance behind student score tracking.

---

## 🖥️ UI Showcase

(<img width="1351" height="639" alt="image" src="https://github.com/user-attachments/assets/e53bb160-86fe-40f4-9ff1-deeae937838f" />
)
*Figure 1: Reactive Dark-Themed Analytical Prediction Interface.*

---

## 🧠 What I Learned Through This Project

Building this full-stack Machine Learning application provided invaluable practical experience across data engineering, API construction, and client-side design:

1. **Bridge Building (Flask 🤝 Flutter):** Handling API data structures taught me the critical nature of type-casting and formatting data safely across systems (e.g., converting dynamic JSON payloads safely down into predictable Dart variables like `double`).
2. **Reactive UX Matters:** Moving away from static, tedious textual data entries to visual input sliders and toggle configurations drastically minimizes user error and makes statistical data modeling engaging.

---

## ⚙️ How to Run the Project

Follow these steps to launch both the backend predictive intelligence engine and the dashboard interface locally.

### 1. Backend (Flask API)
Navigate to your backend directory, ensure you have Python installed, and follow these commands:

```bash
# Install dependencies
pip install flask scikit-learn pandas

# Run the predictive server
python app.py
