
/*
Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.
*/
USE my_shop;
DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';


insert into users(name, created_at, updated_at) 
VALUES('Alex', '2018-10-01 0:00:33', NOW());


INSERT INTO users(name, created_at, updated_at) 
VALUES
('Peter', FROM_UNIXTIME(UNIX_TIMESTAMP('2010-04-30 14:53:27') + FLOOR(0 + (RAND() * 63072000))), NOW()-INTERVAL 1 DAY),
('Mary ',  FROM_UNIXTIME(UNIX_TIMESTAMP('2010-04-30 14:53:27') + 	FLOOR(0 + (RAND() * 63072000))), NOW()-INTERVAL 1 WEEK ),	
('Pavel', FROM_UNIXTIME(UNIX_TIMESTAMP('2010-04-30 14:53:27') + FLOOR(0 + (RAND() * 63072000))), NOW()-INTERVAL 1 YEAR);


UPDATE users SET created_at=NOW(), updated_at=NOW();


SELECT * from users;


/*
Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR 
и в них долгое время помещались значения в формате "20.10.2017 8:10". Необходимо преобразовать поля 
к типу DATETIME, сохранив введеные ранее значения.
*/

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at VARCHAR(255),
  updated_at VARCHAR(255)
) COMMENT = 'Покупатели';

INSERT INTO users(name, created_at, updated_at) 
VALUES
('Alex', '2018-10-01 0:00:33', '2019-10-01 0:00:33'),
('Peter', '2018-10-01 0:00:33', '2019-10-01 0:00:33'),
('Mary', '2018-10-01 0:00:33', '2019-10-01 0:00:33'),
('Pavel', '2018-10-01 0:00:33', '2019-10-01 0:00:33');

SELECT * from users;

/*
DROP TABLE IF EXISTS users_tempo;
CREATE TABLE users_tempo (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';



INSERT INTO
  users_tempo
SELECT  *
FROM
  users;
SELECT * FROM users_tempo;
DROP TABLE users;
ALTER TABLE users_tempo RENAME users;

*/

ALTER TABLE users MODIFY created_at DATETIME;
ALTER TABLE users MODIFY updated_at DATETIME;






/*
В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 
0, если товар закончился и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи 
таким образом, чтобы они выводились в порядке увеличения значения value. Однако, нулевые запасы должны 
выводиться в конце, после всех записей.
*/


DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
  storehouse_id INT UNSIGNED,
  product_id INT UNSIGNED,
  value INT UNSIGNED COMMENT 'Запас товарной позиции на складе',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Запасы на складе';


insert into storehouses_products
VALUES
(null, 1, 333, 123, '2018-10-01 0:00:33', '2019-10-01 0:00:33'), 
(null, 1, 334, 0, '2018-10-01 0:00:33', '2019-10-01 0:00:33'), 
(null, 1, 335, 12, '2018-10-01 0:00:33', '2019-10-01 0:00:33'), 
(null, 1, 336, 0, '2018-10-01 0:00:33', '2019-10-01 0:00:33'), 
(null, 1, 337, 1230, '2018-10-01 0:00:33', '2019-10-01 0:00:33'), 
(null, 1, 338, 1, '2018-10-01 0:00:33', '2019-10-01 0:00:33'), 
(null, 1, 339, 3, '2018-10-01 0:00:33', '2019-10-01 0:00:33');

select * from storehouses_products;

ALTER TABLE storehouses_products ADD mark SMALLINT UNSIGNED;
UPDATE storehouses_products SET mark=1;
UPDATE storehouses_products SET mark=0 WHERE value>0 ;



SELECT id, value  FROM storehouses_products sp ORDER BY mark, value;
ALTER TABLE storehouses_products DROP mark;


-- select * from storehouses_products;







