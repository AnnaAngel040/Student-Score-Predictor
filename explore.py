import pandas as pd

df = pd.read_csv("SAP-4000.csv")

df = df.drop(columns=["Parent Education"])

print(df.describe())