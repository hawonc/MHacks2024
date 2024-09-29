import requests
import csv
import io

# Set the base URL for the Flask server
# base_url = 'http://34.45.71.72'
base_url = 'http://127.0.0.1:5000'

# Create a new table in the database

# response = requests.post(f'{base_url}/create_table', json={
#     'database_name': 'medInfo',
#     'table_name': 'test_table',
# })
# print(response.json())
requests.get(f'{base_url}/get_tables')

# Add some rows to the table
rows = [
    {'MedName': 'Aspirin', 'MedType': 'Pills', 'ImageLocation': '/images/aspirin.jpg', 'Quantity': 50, 'UpdateDate': '2022-01-01 12:00:00'},
    {'MedName': 'Ibuprofen', 'MedType': 'Pills', 'ImageLocation': '/images/ibuprofen.jpg', 'Quantity': 30, 'UpdateDate': '2022-01-02 10:00:00'}
]
response = requests.post(f'{base_url}/add_rows', json={
    'database_name': 'medInfo',
    'table_name': 'test_table',
    'rows': rows
})
print(response.json())

rows = [
    {'MedName': 'Ibuprofen', 'MedType': 'Pills', 'ImageLocation': '/images/ibuprofen.jpg', 'Quantity': 32, 'UpdateDate': '2022-01-02 10:00:00'}
]
response = requests.post(f'{base_url}/add_rows', json={
    'database_name': 'medInfo',
    'table_name': 'test_table',
    'rows': rows
})
print(response.json())

response = requests.get(f'{base_url}/export_csv/test_table')
csv_file = io.StringIO(response.text)
reader = csv.DictReader(csv_file)
with open('test_table.csv', 'wb') as f:
    f.write(response.content)
# Export the table as a CSV file
response = requests.get(f'{base_url}/export_table/test_table')
print(response.json())
