
/* Задача 01
Написать крипт, добавляющий в БД vk, которую создали на занятии, 
3 новые таблицы (с перечнем полей, указанием индексов и внешних ключей)
*/


USE vk;

DROP TABLE IF EXISTS banned_chel;
CREATE TABLE banned_chel (

	initiator_user_id BIGINT UNSIGNED NOT NULL,
    target_user_id BIGINT UNSIGNED NOT NULL,
    
    
    
	banned_at DATETIME DEFAULT NOW(),
	
	
    PRIMARY KEY (initiator_user_id, target_user_id),
	INDEX (initiator_user_id), -- потому что обычно будем искать забанненых конкретного пользователя
    INDEX (target_user_id),
    FOREIGN KEY (initiator_user_id) REFERENCES users(id),
    FOREIGN KEY (target_user_id) REFERENCES users(id)
);



DROP TABLE IF EXISTS audio_albums;
CREATE TABLE audio_albums (
	`id` SERIAL,
	`name` varchar(255) DEFAULT NULL,
    `user_id` BIGINT UNSIGNED DEFAULT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id),
  	PRIMARY KEY (`id`)
);







DROP TABLE IF EXISTS audio;
CREATE TABLE audio (
	id SERIAL PRIMARY KEY,
	`album_id` BIGINT unsigned NOT NULL,
	`media_id` BIGINT unsigned NOT NULL,

	FOREIGN KEY (album_id) REFERENCES audio_albums(id),
    FOREIGN KEY (media_id) REFERENCES media(id)
);




