from flask import Flask, request, send_file, jsonify
import mariadb
import io
import csv

app = Flask(__name__)

# Replace these values with your own MariaDB credentials
db = mariadb.connect(
  host="localhost",
  user="root",
  password="root",
  database="medInfo"
)

cursor = db.cursor()
columns = [{'name' : 'MedName', 'type' : 'TEXT'},
            {'name' : 'MedType', 'type' : 'TEXT'},
            {'name' : 'ImageLocation', 'type' : 'TEXT'},
            {'name' : 'Quantity', 'type' : 'INT'},
            {'name' : 'UpdateDate', 'type' : 'TIMESTAMP'}
            ]

@app.route('/', methods=['GET'])
def m():
    return ("you shouldn't be here")

@app.route('/get_tables', methods=['GET'])
def get_tables():
    cursor.execute(f"SHOW TABLES FROM medInfo")
    r = cursor.fetchall()
    print (r)
    return (r)


@app.route('/create_table', methods=['POST'])
def create_table():
    data = request.get_json()
    table_name = data['table_name']

    query = f"CREATE TABLE {table_name} ("
    for column in columns:
        query += f"{column['name']} {column['type']}, "
    query = query[:-2] + ")"

    cursor.execute(query)
    db.commit()

    return {'message': f'Table {table_name} created successfully'}

@app.route('/add_rows', methods=['POST'])
def add_row():
    data = request.get_json()
    table_name = data['table_name']
    rows = data['rows']  # This should be a list of dictionaries, each containing the column names and values

    for row in rows:
        name = row['MedName']
        query = f"SELECT * FROM {table_name} WHERE MedName = '{name}'"
        cursor.execute(query)
        result = cursor.fetchone()
        if result:
            # Update existing row
            query = f"UPDATE {table_name} SET "
            for column, value in row.items():
                query += f"{column} = '{value}', "
            query = query[:-2] + f" WHERE MedName = '{name}'"
        else:
            # Insert new row
            query = f"INSERT INTO {table_name} ("
            for column in row.keys():
                query += f"{column}, "
            query = query[:-2] + ") VALUES ("
            for value in row.values():
                query += f"'{value}', "
            query = query[:-2] + ")"
        cursor.execute(query)
        db.commit()

    return {'message': 'Row added successfully'}

@app.route('/export_table/<table_name>', methods=['GET'])
def export_table(table_name):
    query = f"SELECT * FROM {table_name}"
    cursor.execute(query)
    rows = cursor.fetchall()

    # Convert the rows to a dictionary
    data = {}
    i = 0
    for row in rows:
        i += 1
        data[i] = list(row)
    
    print(data)

    return (data)

@app.route('/export_csv/<table_name>', methods=['GET'])
def export_csv(table_name):
    query = f"SELECT * FROM {table_name}"
    cursor.execute(query)
    rows = cursor.fetchall()

    # Create a CSV file in memory
    csv_file = io.StringIO()
    writer = csv.writer(csv_file)

    # Write the column headers
    headers = [i[0] for i in cursor.description]
    writer.writerow(headers)

    # Write the data rows
    for row in rows:
        writer.writerow(row)

    # Set the file pointer to the beginning of the file
    csv_file.seek(0)
    csv_bytes = io.BytesIO(csv_file.getvalue().encode())

    # Send the CSV file as a response
    return send_file(
        csv_bytes,
        mimetype='text/csv',
        download_name=f'{table_name}.csv',
        as_attachment=True
    )


@app.route('/import_csv', methods=['POST'])
def import_csv():
    # Get the CSV file from the request
    csv_file = request.files['file']

    # Read the CSV file into a list of dictionaries
    reader = csv.DictReader(csv_file.read().decode('utf-8').splitlines())
    rows = list(reader)

    # Create a new table with the same columns as the CSV file
    table_name = request.form['table_name']
    query = f"CREATE TABLE {table_name} ("
    for column in reader.fieldnames:
        query += f"{column} VARCHAR(255), "
    query = query[:-2] + ")"
    cursor.execute(query)
    db.commit()

    # Insert the data rows into the new table
    query = f"INSERT INTO {table_name} ("
    for column in reader.fieldnames:
        query += f"{column}, "
    query = query[:-2] + ") VALUES ("
    for row in rows:
        query += "("
        for value in row.values():
            query += f"'{value}', "
        query = query[:-2] + "), "
    query = query[:-2]
    cursor.execute(query)
    db.commit()

    return {'message': 'CSV file imported successfully'}

if __name__ == '__main__':
    app.run(host='0.0.0.0')