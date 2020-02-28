



/*
1.) В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. 
Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.
*/

DROP DATABASE IF EXISTS shop;
CREATE DATABASE shop;
USE shop;


DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';



DROP DATABASE IF EXISTS sample;
CREATE DATABASE sample;
USE sample;


DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';


INSERT INTO shop.users VALUES
  (DEFAULT, 'Piter', '2007-08-01', DEFAULT, DEFAULT),
  (DEFAULT, 'Anna',  '2001-08-02', DEFAULT, DEFAULT),
  (DEFAULT, 'Elvis', '2010-08-03', DEFAULT, DEFAULT);

  
select * FROM  shop.users;
select * FROM  sample.users; 
 
BEGIN;
	INSERT INTO sample.users SELECT * FROM shop.users WHERE shop.users.id = 1;
	DELETE FROM shop.users WHERE shop.users.id=1;
COMMIT;
 
select * FROM  shop.users;
select * FROM  sample.users;

-- ==================================================================================================================
/* 
2.)Создайте представление, которое выводит название name товарной позиции из таблицы products и 
соответствующее название каталога name из таблицы catalogs.
*/

DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) UNIQUE COMMENT 'Название раздела' 
) COMMENT = 'Разделы интернет-магазина';

INSERT INTO catalogs VALUES
  (DEFAULT, 'White'),
  (DEFAULT, 'Blue'),
  (DEFAULT, 'Red');




DROP TABLE IF EXISTS products;
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название',
  desription TEXT COMMENT 'Описание',
  price DECIMAL (11,2) COMMENT 'Цена',
  catalog_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Товарные позиции';



INSERT INTO products VALUES
  (DEFAULT, 'Fish',   'a',100, 1, DEFAULT, DEFAULT),
  (DEFAULT, 'spyder', 'b',200, 2, DEFAULT, DEFAULT),
  (DEFAULT, 'beard',  'c',300, 1, DEFAULT, DEFAULT);

SELECT * FROM catalogs;
SELECT * FROM products;




CREATE OR REPLACE VIEW namecat AS
SELECT p.name as product_name, c.name as catalog_name
FROM catalogs AS c
JOIN products AS p 
WHERE c.id = p.catalog_id;


SELECT * FROM namecat;








/*
1.)Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. 
С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу 
"Добрый день", с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи"
*/


DROP FUNCTION IF EXISTS greet_day;

CREATE FUNCTION greet_day ()
RETURNS TINYTEXT NOT DETERMINISTIC
BEGIN
DECLARE mess TINYTEXT;
IF CURTIME()  BETWEEN '06:00:00' AND '12:00:00' THEN SET mess="MORNING";
ELSEIF CURTIME()  BETWEEN '12:00:00' AND '18:00:00' THEN SET mess="AFTERNOON";
ELSEIF CURTIME()  BETWEEN '18:00:00' AND '00:00:00' THEN SET mess="EVENING";
ELSEIF CURTIME()  BETWEEN '00:00:00' AND '06:00:00' THEN SET mess="NIGHT";

END IF;
RETURN mess;
END


SELECT greet_day();






/*
2.)В таблице products есть два текстовых поля: name с названием товара и description с его описанием. 
Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное 
значение NULL неприемлема. Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. 
При попытке присвоить полям NULL-значение необходимо отменить операцию
*/

SELECT * FROM products;


CREATE TRIGGER check_product BEFORE INSERT ON products
FOR EACH ROW
BEGIN
DECLARE prod_name VARCHAR(255);
DECLARE prod_de TEXT;

IF (NEW.desription AND NEW.name) IS NULL
THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'insert canceled';
END IF;


SELECT name INTO prod_name FROM products ORDER BY name LIMIT 1;
SET NEW.name = COALESCE(NEW.name, prod_name);


SELECT desription INTO prod_de FROM products ORDER BY desription LIMIT 1;
SET NEW.desription = COALESCE(NEW.desription, prod_de);

END;




INSERT INTO products VALUES
  (DEFAULT, NULL, 'eeeeeee', 100, 1, DEFAULT, DEFAULT);

INSERT INTO products VALUES
  (DEFAULT, NULL, NULL, 100, 1, DEFAULT, DEFAULT);



CREATE TRIGGER check_product BEFORE UPDATE ON products
FOR EACH ROW
BEGIN
DECLARE prod_name VARCHAR(255);
DECLARE prod_de TEXT;

IF (NEW.desription AND NEW.name) IS NULL
THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'insert canceled';
END IF;


SELECT name INTO prod_name FROM products ORDER BY name LIMIT 1;
SET NEW.name = COALESCE(NEW.name, prod_name);


SELECT desription INTO prod_de FROM products ORDER BY desription LIMIT 1;
SET NEW.desription = COALESCE(NEW.desription, prod_de);

END;











