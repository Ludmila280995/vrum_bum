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
    auto_id INTEGER REFERENCES car_shop.cars(id) NOT NULL, /* Для согласования с первичным ключом. */
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


