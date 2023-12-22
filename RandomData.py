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
    'T1Accuracy_Lag1': [0.75, 0.85],
    'T2Accuracy_Lag1': [1, 1],
    'T1Accuracy_Lag2': [0.85, 0.95],
    'T2Accuracy_Lag2': [1, 1],
    'T1Accuracy_Lag3': [0.9, 1],
    'T2Accuracy_Lag3': [1, 1],
    'T1Accuracy_Lag4': [0.9, 1],
    'T2Accuracy_Lag4': [1, 1],
    'T1Accuracy_Lag5': [0.9, 1],
    'T2Accuracy_Lag5': [1, 1],
    'T1Accuracy_Lag6': [0.9, 1],
    'T2Accuracy_Lag6': [1, 1],
    'T1Accuracy_Lag7': [0.9, 1],
    'T2Accuracy_Lag7': [1, 1],
    'T1Accuracy_Lag8': [0.88, 0.98],
    'T2Accuracy_Lag8': [1, 1],
    'T2_T1Accuracy_Lag1': [0.9, 0.95],
    'T2_T1Accuracy_Lag2': [0.65, 0.75],
    'T2_T1Accuracy_Lag3': [0.7, 0.8],
    'T2_T1Accuracy_Lag4': [0.75, 0.85],
    'T2_T1Accuracy_Lag5': [0.85, 0.95],
    'T2_T1Accuracy_Lag6': [0.85, 0.95],
    'T2_T1Accuracy_Lag7': [0.83, 0.93],
    'T2_T1Accuracy_Lag8': [0.81, 0.91],
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
    'T2_T1Accuracy_Lag1': 2,
    'T2_T1Accuracy_Lag2': 2,
    'T2_T1Accuracy_Lag3': 2,
    'T2_T1Accuracy_Lag4': 2,
    'T2_T1Accuracy_Lag5': 2,
    'T2_T1Accuracy_Lag6': 2,
    'T2_T1Accuracy_Lag7': 2,
    'T2_T1Accuracy_Lag8': 2,
}

# 数字表示保存X行数据
add_random_data_to_csv(25, range_dict, decimal_dict)