import os
import csv


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
    if n_attribute == 0 or n_attribute == 3 or n_attribute == 4 or n_attribute == 7 or n_attribute == 9:
        if n_attribute == 9:
            m = map(float, attr)
        else:
            m = map(int, attr)
        v = list(m)
        order_attr = bubbleSort(v)
        return order_attr
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
        attribute = 'fastingBP'
    elif n_attribute == 6:
        attribute = 'restingECG'
    elif n_attribute == 7:
        attribute = 'maxHR'
    elif n_attribute == 8:
        attribute = 'exercise_angina'
    elif n_attribute == 9:
        attribute = 'oldpeak'
    elif n_attribute == 10:
        attribute = 'ST_slope'

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


def write_examples(pl_file: str, file_path: str):
    ex_value = []
    f = open(file_path)
    csv_file = csv.reader(f)
    for row in csv_file:
        if csv_file.line_num == 1:
            continue

        """DA FINIRE"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

    f.close()
    return ex_value

if __name__ == '__main__':
    filepath = './heart.csv'
    pl_file = 'db_hearth.pl'

    """PRINT TO TERMINAL TEST"""
    print(take_attributesName(filepath))
    # print(take_attributes(csv_f, 10))

    """WRITE A PROLOG DATABASE"""
    i = 0
    while i <= 10:
        write_attributes(pl_file, filepath, i)
        i += 1
