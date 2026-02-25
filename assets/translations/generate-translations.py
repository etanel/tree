import csv
import json
import os
import requests

dir_path = os.path.dirname(os.path.realpath(__file__)) + "\\"

csv_file_name = 'translations.csv'

google_sheets_url = 'https://docs.google.com/spreadsheets/d/1QQqt28cmrby6JqxLm-oxUXCuM3alniLJ6IRhcPJDOtk/gviz/tq?tqx=out:csv'

print("Downloading CSV...")

response = requests.get(google_sheets_url)

if response.status_code == 200:
    with open(dir_path + csv_file_name, 'wb') as csv_file:
        csv_file.write(response.content)
    print('CSV file downloaded successfully')
else:
    print('Failed to download CSV - status code: ', response.status_code)

print("Reading", dir_path + csv_file_name)


# Read the CSV file
with open(dir_path + csv_file_name, 'r', encoding='utf-8') as file:
    reader = csv.reader(file)
    rows = list(reader)

# Get the header row containing the languages
languages = rows[0][1:]

# Define the languages you want to include
desired_languages = ['English', 'Spanish', 'Kiswahili']  # Adjust these names to match your CSV headers

print("Generating files for:", desired_languages)

# Generate the output files
for current_lang_index, lang in enumerate(languages, start=1):
    # Check if this language is in our desired list
    if lang in desired_languages:
        print("Current Language - " + lang)
        current_lang_data = {}
        for row in rows[2:]:
            if row[current_lang_index]=="": continue
            current_lang_data[row[0]] = row[current_lang_index]

        # Write the JSON file
        with open(dir_path + "generated/" + lang + ".json", 'w', encoding='utf-8') as file:
            json.dump(current_lang_data, file, indent=2, ensure_ascii=False)

print("Done!")