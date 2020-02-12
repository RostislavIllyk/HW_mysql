use vk;

/*
ii. Написать скрипт, возвращающий список имен (только firstname) пользователей без повторений в алфавитном порядке
*/

select distinct firstname from users order by firstname ;






/*
iii. Написать скрипт, отмечающий несовершеннолетних пользователей как неактивных (поле is_active = false). 
Предварительно добавить такое поле в таблицу profiles со значением по умолчанию = true (или 1)
*/

-- ALTER TABLE profiles DROP COLUMN  is_active;
--  Эта конструкция почемуто не работает !!!        ALTER TABLE profiles DROP IF EXISTS is_active;


ALTER TABLE profiles ADD is_active ENUM('True', 'False') DEFAULT 'True';

UPDATE profiles SET is_active ="False"
WHERE
	(YEAR(CURRENT_DATE)-YEAR(birthday))-(RIGHT(CURRENT_DATE,5)<RIGHT(birthday,5)) <18;

SELECT * FROM vk.profiles;




/*
iv. Написать скрипт, удаляющий сообщения «из будущего» (дата позже сегодняшней)
*/

insert into messages(id, from_user_id, to_user_id, body, created_at)
 VALUES(NULL, 1, 1, 'rrrrrrr', CURRENT_DATE+3);

select * from messages  WHERE created_at > CURRENT_DATE; 

DELETE from messages  WHERE created_at > CURRENT_DATE; 



