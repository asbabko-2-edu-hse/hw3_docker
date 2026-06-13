import csv
import random
import os
import sys

NUM_ROWS = 50


COLUMNS = ["name", "faculty", "course", "programme"]

def generate_row():

    names = ["Анастасия", "Елизавета", "Михаил", "Роман", "Анна", "Сергей", "Ксения", "Софья", "Александр", "Ирина"]

    faculties = ["ВШБ", "ФКН", "ФГН", "ФЭН"]

    courses = [1, 2, 3, 4]

    programmes = ["Бизнес-информатика", "Управление бизнесом", "Маркетинг и рыночная аналитика", "Экономика",
                  "Экономика и анализ данных", "Прикладной анализ данных", "Прикладная математика и информатика",
                  "История искусств", "Культурология"]

    return {
        "name": random.choice(names),
        "faculty": random.choice(faculties),
        "course": random.choice(courses),
        "programme": random.choice(programmes),
    }

OUTPUT_DIR = sys.argv[1] if len(sys.argv) > 1 else "/data"
OUTPUT_FILE = os.path.join(OUTPUT_DIR, "data.csv")

os.makedirs(OUTPUT_DIR, exist_ok=True)

rows = [generate_row() for _ in range(NUM_ROWS)]

with open(OUTPUT_FILE, "w", newline="", encoding="utf-8") as f:
    writer = csv.DictWriter(f, fieldnames=COLUMNS)
    writer.writeheader()
    writer.writerows(rows)
