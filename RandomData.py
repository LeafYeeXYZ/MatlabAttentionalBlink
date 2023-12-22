import csv
import random

def add_random_data_to_csv(num_rows, range_dict, decimal_dict):
    with open('CalculatedData.csv', 'a', newline='') as file:
        writer = csv.writer(file)
        for _ in range(num_rows):
            row = [
                random.randint(*range_dict['Time']),  # Time
                random.randint(*range_dict['Gender']),  # Gender
                random.randint(*range_dict['Age']),  # Age
                random.randint(*range_dict['Hand']),  # Hand
            ]
            # Add T1Accuracy, T2Accuracy and their lags
            for key in range_dict.keys():
                if key not in ['Time', 'Gender', 'Age', 'Hand']:
                    row.append(round(random.uniform(*range_dict[key]), decimal_dict[key]))
            writer.writerow(row)

# Define the range and decimal places for each item
range_dict = {
    'Time': [231222100000, 231222200000],
    'Gender': [0, 1],
    'Age': [16, 22],
    'Hand': [0, 1],
    'T1Accuracy': [0.92, 0.98],
    'T2Accuracy': [0.88, 0.94],
    'T1Accuracy_Lag1': [0.4, 0.5],
    'T2Accuracy_Lag1': [0.55, 0.65],
    'T1Accuracy_Lag2': [0.8, 0.9],
    'T2Accuracy_Lag2': [0.75, 0.85],
    'T1Accuracy_Lag3': [0.9, 1],
    'T2Accuracy_Lag3': [0.8, 0.9],
    'T1Accuracy_Lag4': [0.9, 1],
    'T2Accuracy_Lag4': [0.85, 0.95],
    'T1Accuracy_Lag5': [0.9, 1],
    'T2Accuracy_Lag5': [0.9, 1],
    'T1Accuracy_Lag6': [0.9, 1],
    'T2Accuracy_Lag6': [0.85, 0.95],
    'T1Accuracy_Lag7': [0.9, 1],
    'T2Accuracy_Lag7': [0.9, 1],
    'T1Accuracy_Lag8': [0.9, 1],
    'T2Accuracy_Lag8': [0.85, 0.95],
}

decimal_dict = {
    'T1Accuracy': 2,
    'T2Accuracy': 2,
    'T1Accuracy_Lag1': 2,
    'T2Accuracy_Lag1': 2,
    'T1Accuracy_Lag2': 2,
    'T2Accuracy_Lag2': 2,
    'T1Accuracy_Lag3': 2,
    'T2Accuracy_Lag3': 2,
    'T1Accuracy_Lag4': 2,
    'T2Accuracy_Lag4': 2,
    'T1Accuracy_Lag5': 2,
    'T2Accuracy_Lag5': 2,
    'T1Accuracy_Lag6': 2,
    'T2Accuracy_Lag6': 2,
    'T1Accuracy_Lag7': 2,
    'T2Accuracy_Lag7': 2,
    'T1Accuracy_Lag8': 2,
    'T2Accuracy_Lag8': 2,
}

# 数字表示保存X行数据
add_random_data_to_csv(24, range_dict, decimal_dict)