/* Создайте схему raw_data и таблицу sales в этой схеме. */
CREATE SCHEMA raw_data;

CREATE TABLE raw_data.sales(
    id SERIAL PRIMARY KEY,
    auto varchar,
    gasoline_consumption NUMERIC,
    price NUMERIC,
    date DATE,
    person_name varchar,
    phone varchar,
    discount INTEGER,
    brand_origin varchar);

/* Заполните таблицу sales данными, используя команду \copy в psql. */
\copy raw_data.sales(id,auto,gasoline_consumption,price,date,person_name,phone,discount,brand_origin) FROM 'C:\cars.csv' CSV HEADER NULL 'null';