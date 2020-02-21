-- set names 'utf8';


USE my_shop;



/*

Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.

*/



DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id)
) COMMENT = 'Заказы';


insert into orders (user_id) values(2);
insert into orders (user_id) values(2);
insert into orders (user_id) values(3);
insert into orders (user_id) values(4);

-- SELECT  user_id  from orders;
-- SELECT DISTINCT user_id  from orders;
-- SELECT * from users;

SELECT name FROM users WHERE id in (SELECT DISTINCT user_id  from orders);





/*
Выведите список товаров products и разделов catalogs, который соответствует товару.
*/




DROP TABLE IF EXISTS products;
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название',
  desription TEXT COMMENT 'Описание',
  price DECIMAL (11,2) COMMENT 'Цена',
  catalog_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_catalog_id (catalog_id)
) COMMENT = 'Товарные позиции';

insert into products (name, desription, price, catalog_id) values
('monk', 'fish', 123.33, 1),
('dorado', 'fish', 333.33, 1),
('spider', 'insect', 222.33, 3),
('cucaracha', 'insect', 1000.33, 3);


-- SELECT * from products;
-- SELECT * from catalogs;

SELECT name,  (select name from catalogs WHERE catalogs.id = products.catalog_id) as subj from products;




/*
(по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). 
Поля from, to и label содержат английские названия городов, поле name — русское. 
Выведите список рейсов flights с русскими названиями городов.

*/



DROP TABLE IF EXISTS flights;
CREATE TABLE flights (
  id SERIAL PRIMARY KEY,
  `from` VARCHAR(191) COMMENT 'Вылет',
  `to` VARCHAR(191)  COMMENT 'Прибытие'
);

DROP TABLE IF EXISTS cities;
CREATE TABLE cities (
  `label` VARCHAR(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci ,
  `name` VARCHAR(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci
);

insert into cities (`label`, `name`) values
('Moscow', 'Москва'),
('Irkutsk', 'Иркутск'),
('Novgorod', 'Новгород'),
('Kazan', 'Казань'),
('Omsk', 'Омск')
;

--  select * from cities ;

insert into flights (`from`, `to`) values
('Moscow', 'Omsk'),
('Novgorod', 'Kazan'),
('Irkutsk', 'Moscow'),
('Omsk', 'Irkutsk'),
('Moscow', 'Kazan')
;

-- select * from flights ;




select id, (select `name` from cities WHERE flights.`from` = cities.`label`) as `departure` ,
	(select `name` from cities WHERE flights.`to` = cities.`label`) as `arrival`
from flights ;





















