import os
import csv
import random


def bubbleSort(v):
    fine = len(v) - 1
    ultimoScambio = 0
    while ultimoScambio > -1:
        ultimoScambio = -1
        for i in range(fine):
            if v[i] > v[i + 1]:
                temp = v[i]
                v[i] = v[i + 1]
                v[i + 1] = temp
                ultimoScambio = i
        fine = ultimoScambio
    return v


def take_attributesName(file_path: str) -> list:
    attrName = []
    f = open(file_path)
    csv_file = csv.reader(f)
    for row in csv_file:
        if csv_file.line_num == 1:
            for attr in row:
                attrName.append(attr)
    f.close()
    return attrName


def take_attributes(file_path: str, n_attribute: int) -> list:
    attr = []
    f = open(file_path)
    csv_file = csv.reader(f)
    for row in csv_file:
        if csv_file.line_num == 1:
            continue
        if row[n_attribute] not in attr:
            attr.append(row[n_attribute])
    f.close()

    if n_attribute == 5:
        m = map(int, attr)
        attr = list(m)
    if n_attribute == 0:
        attr = ["First", "Second", "Third"]
    if n_attribute == 3:
        attr = ["Optimal", "Normal/high", "High", "Very high"]
    if n_attribute == 4:
        attr = ["Desiderable", "Moderately high", "Extremely high"]
    if n_attribute == 7:
        attr = [1, 2, 3, 4]
    if n_attribute == 9:
        attr = ["Low risk", "Normal risk", "High risk"]

    return attr


def write_attributes(filename: str, file_path: str, n_attribute: int):
    attr = take_attributes(file_path, n_attribute)
    attribute = ''
    type_of_writing = 'a'
    if n_attribute == 0:
        attribute = 'age'
        type_of_writing = 'w'
    elif n_attribute == 1:
        attribute = 'sex'
    elif n_attribute == 2:
        attribute = 'chest_pain_type'
    elif n_attribute == 3:
        attribute = 'restingBP'
    elif n_attribute == 4:
        attribute = 'cholesterol'
    elif n_attribute == 5:
        attribute = 'fastingBS'
    elif n_attribute == 6:
        attribute = 'restingECG'
    elif n_attribute == 7:
        attribute = 'maxHR'
    elif n_attribute == 8:
        attribute = 'exercise_angina'
    elif n_attribute == 9:
        attribute = 'oldpeak'
    elif n_attribute == 10:
        attribute = 'st_slope'

    f = open(filename, type_of_writing)
    if isinstance(attr[0], int) or isinstance(attr[0], float):
        f.write('a(' + attribute + ',[' + str(attr[0]))
        for item in attr[1:]:
            f.write(',' + str(item))
    else:
        f.write('a(' + attribute + ',[' + '"' + attr[0] + '"')
        for item in attr[1:]:
            f.write(',' + '"' + item + '"')
    f.write(']).\n')
    f.close()


def discr_example(row_e: list) -> list:
    """age"""
    if int(row_e[0]) <= 18:
        row_e[0] = 'First'
    elif 18 < int(row_e[0]) <= 60:
        row_e[0] = 'Second'
    elif int(row_e[0]) > 60:
        row_e[0] = 'Third'

    """restingBP"""
    if int(row_e[3]) < 120:
        row_e[3] = 'Optimal'
    elif 120 <= int(row_e[3]) < 140:
        row_e[3] = 'Normal/high'
    elif 140 <= int(row_e[3]) < 160:
        row_e[3] = 'High'
    elif int(row_e[3]) >= 160:
        row_e[3] = 'Very high'

    """cholesterol"""
    if int(row_e[4]) < 200:
        row_e[4] = 'Desiderable'
    elif 200 <= int(row_e[4]) < 240:
        row_e[4] = 'Moderately high'
    elif int(row_e[4]) >= 240:
        row_e[4] = 'Extremely high'

    """maxHR"""
    if int(row_e[7]) < 100:
        row_e[7] = '1'
    elif 100 <= int(row_e[7]) < 130:
        row_e[7] = '2'
    elif 130 <= int(row_e[7]) < 160:
        row_e[7] = '3'
    elif int(row_e[7]) >= 160:
        row_e[7] = '4'

    """oldpeak"""
    if float(row_e[9]) < 0.5:
        row_e[9] = 'Low risk'
    elif 0.5 <= float(row_e[9]) < 1.5:
        row_e[9] = 'Normal risk'
    elif float(row_e[9]) >= 1.5:
        row_e[9] = 'High risk'

    return row_e


def write_examples(pl_file: str, file_path: str):
    ex_value = []
    f = open(file_path)
    csv_file = csv.reader(f)
    f2 = open(pl_file, 'w')
    for row in csv_file:
        if csv_file.line_num == 1:
            continue
        # tolgo gli esempi con valori a 0
        if row[3] == '0' or row[4] == '0':
            continue
        row_d = discr_example(row)
        print(row_d)
        f2.write('e(' + ('y' if row_d[11] == '1' else 'n') + ',[age = ' + '"' + row_d[0] + '"' + ','
                 + ' sex = ' + '"' + row_d[1] + '"' + ','
                 + ' chest_pain_type = ' + '"' + row_d[2] + '"' + ','
                 + ' restingBP = ' + '"' + row_d[3] + '"' + ','
                 + ' cholesterol = ' + '"' + row_d[4] + '"' + ','
                 + ' fastingBS = ' + row_d[5] + ','
                 + ' restingECG = ' + '"' + row_d[6] + '"' + ','
                 + ' maxHR = ' + row_d[7] + ','
                 + ' exercise_angina = ' + '"' + row_d[8] + '"' + ','
                 + ' oldpeak = ' + '"' + row_d[9] + '"' + ','
                 + ' st_slope = ' + '"' + row_d[10] + '"' + ']).\n'
                 )

    f.close()
    f2.close()
    return ex_value


def create_testset(file: str):
    reading_file = open(file, "r")
    new_file_content = ""
    for line in reading_file:
        stripped_line = line.strip()
        new_line = stripped_line.replace("e(", "s(")
        new_file_content += new_line + "\n"
    reading_file.close()

    writing_file = open(file, "w")
    writing_file.write(new_file_content)
    writing_file.close()


def manipolate_examples(file: str, perc: int):
    reading_file = open(file, "r")
    lines = reading_file.readlines()
    reading_file.close()
    n_lines = len(lines)
    n_tests = (n_lines * perc) / 100
    new_file_content = ""

    # sequential choice of lines that will be part of Test set
    i = 0
    while i < int(n_tests):
        new_file_content += lines[0]
        del lines[0]
        i += 1

    """j = 0
    selected_lines = random.sample(range(746), int(n_tests))
    print(selected_lines)
    while j < int(n_tests):
        print(selected_lines[j])
        new_file_content += lines[selected_lines[j]]
        j += 1"""

    #print(new_file_content.splitlines())
    # write training set
    writing_train = open('db_heart_training.pl', "w")
    for line in lines:
        writing_train.write(line)
    writing_train.close()

    # write test set
    writing_test = open('db_heart_test.pl', "w")
    writing_test.write(new_file_content)
    writing_test.close()

    # change every examples e(...) in test with s(...)
    create_testset('db_heart_test.pl')


if __name__ == '__main__':
    filepath = './heart.csv'
    pl_attribute_file = 'db_heart_attributes.pl'
    pl_ex_file = 'db_heart_examples.pl'

    """PRINT TO TERMINAL TEST"""
    """print(take_attributesName(filepath))"""

    """WRITE A PROLOG DATABASE"""
    """i = 0
    while i <= 10:
        write_attributes(pl_attribute_file, filepath, i)
        i += 1
    write_examples(pl_ex_file, filepath)"""

    """CREATE TRAINING SET AND TEST SET"""
    manipolate_examples(pl_ex_file, 95)
    """line = 'e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).'
    lines = ['e(y,[age = "Second", sex = "F", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).', 'ciao', 'e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).']
    print(line not in lines)"""
