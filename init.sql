/* Создайте схему raw_data и таблицу sales в этой схеме.*/
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
    brand_origin varchar
);

/* Заполните таблицу sales данными, используя команду \copy в psql. */
\copy raw_data.sales(id,auto,gasoline_consumption,price,date,person_name,phone,discount,brand_origin) FROM 'C:\cars.csv' CSV HEADER NULL 'null';


/* Создайте схему car_shop, а в ней cоздайте нормализованные таблицы. */
CREATE schema car_shop;

CREATE TABLE car_shop.clients(
	id SERIAL PRIMARY KEY, /* Автоматическое присваивание и увеличение id. */
    client_name VARCHAR NOT NULL, /* Занимает меньше оперативной памяти. */
    phone VARCHAR NOT NULL unique /* Может содержать цифры, буквы, символы. */
); 

CREATE TABLE car_shop.colors (
    id SERIAL PRIMARY KEY, /* Автоматическое присваивание и увеличение id. */
    name VARCHAR NOT NULL UNIQUE /* Занимает меньше оперативной памяти. */
);

CREATE TABLE car_shop.countries (
    id SERIAL PRIMARY KEY, /* Автоматическое присваивание и увеличение id. */
    name VARCHAR NOT NULL UNIQUE /* Занимает меньше оперативной памяти. */
);

CREATE TABLE car_shop.cars (
    id SERIAL PRIMARY KEY, /* Автоматическое присваивание и увеличение id. */
    brand_name VARCHAR NOT NULL, /* Занимает меньше оперативной памяти. */
    model_name VARCHAR NOT NULL, /* Может содержать цифры, буквы, символы. */
    gasoline_consumption NUMERIC, /* Повышенная точность. При различных операциях с данными дробные числа не потеряются. */
    country_id INTEGER REFERENCES car_shop.countries(id), /* Согласование с первичным ключом. */
    UNIQUE (brand_name, model_name)
);

CREATE TABLE car_shop.cars_colors (
    car_id INTEGER REFERENCES car_shop.cars(id) NOT NULL, /* Для согласования с первичным ключом. */
    color_id INTEGER REFERENCES car_shop.colors(id) NOT NULL, /* Для согласования с первичным ключом. */
    PRIMARY KEY(auto_id, color_id)
);

CREATE TABLE car_shop.sales (
    id SERIAL PRIMARY KEY, /* Автоматическое присваивание и увеличение id. */
    price NUMERIC NOT NULL, /* Повышенная точность. */
    date DATE NOT NULL, /* Дата для даты, все логично :з */
    discount SMALLINT, /* Экономит память, значение не превысит пределов. */
    auto_id INTEGER REFERENCES car_shop.cars(id) NOT NULL, /* Для согласования с первичным ключом. */
    client_id INTEGER REFERENCES car_shop.clients(id) NOT NULL /* Для согласования с первичным ключом.*/
);

/* Заполнение таблиц данными. */

INSERT INTO car_shop.clients (client_name, phone)
SELECT DISTINCT s.person_name, s.phone 
FROM raw_data.sales s;

INSERT INTO car_shop.colors (name)
SELECT DISTINCT SPLIT_PART(s.auto, ', ', -1)
FROM raw_data.sales s;

INSERT INTO car_shop.countries (name)
SELECT DISTINCT s.brand_origin
FROM raw_data.sales s
WHERE s.brand_origin IS NOT NULL;

INSERT INTO car_shop.cars (brand_name, model_name, gasoline_consumption, country_id)
SELECT DISTINCT 
    SPLIT_PART(SPLIT_PART(s.auto, ',', 1), ' ', 1),
    SUBSTR(SPLIT_PART(s.auto, ',', 1), STRPOS(SPLIT_PART(s.auto, ',', 1), ' ') + 1),
    s.gasoline_consumption,
    c.id
FROM raw_data.sales s
LEFT JOIN car_shop.countries c ON c.name = s.brand_origin;

INSERT INTO car_shop.cars_colors (car_id, color_id)
SELECT DISTINCT c.id, col.id 
FROM raw_data.sales s
LEFT JOIN car_shop.cars c ON s.auto LIKE (c.brand_name || ' ' || c.model_name || '%')
LEFT JOIN car_shop.colors col ON s.auto LIKE ('%' || col.name);

INSERT INTO car_shop.sales (price, date, discount, auto_id, client_id)
SELECT DISTINCT s.price, s.date, s.discount, a.id, c.id
FROM raw_data.sales s
LEFT JOIN car_shop.cars a ON s.auto LIKE (a.brand_name || ' ' || a.model_name || '%')
LEFT JOIN car_shop.clients c ON c.client_name = s.person_name AND c.phone = s.phone;
