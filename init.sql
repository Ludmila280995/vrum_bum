/* Создайте схему raw_data и таблицу sales в этой схеме. */
CREATE SCHEMA raw_data;

CREATE TABLE raw_data.sales(
id SERIAL PRIMARY KEY,
name TEXT,
phone TEXT,
city TEXT);

/* Заполните таблицу sales данными, используя команду \copy в psql. */
\copy raw_data.sales(id, name, phone, city) FROM 'C:\clients.csv' CSV HEADER NULL 'null';