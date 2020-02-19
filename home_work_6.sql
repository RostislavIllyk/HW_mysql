
/*
Пусть задан некоторый пользователь. Из всех друзей этого пользователя найдите человека, 
который больше всех общался с нашим пользователем.

*/


USE vk;


select to_user_id as friend_id, count(*) as max_amount from
(select to_user_id from messages 
WHERE to_user_id in
(select target_user_id from friend_requests where status ='approved' AND initiator_user_id = 1
UNION
select initiator_user_id from friend_requests where status ='approved' AND target_user_id = 1
) and from_user_id = 1

UNION all

select from_user_id from messages 
WHERE from_user_id in
(select target_user_id from friend_requests where status ='approved' AND initiator_user_id = 1
UNION
select initiator_user_id from friend_requests where status ='approved' AND target_user_id = 1
) and to_user_id = 1) as man

GROUP by to_user_id
LIMIT 1
;




/*
Подсчитать общее количество лайков, которые получили пользователи младше 10 лет..
*/





select count(*) as total from

(select * from likes WHERE user_id in 
(
select user_id from  profiles where birthday < DATE_SUB(NOW(), INTERVAL 10 YEAR)
)) as man
;


/*
Определить кто больше поставил лайков (всего) - мужчины или женщины
*/


SELECT 
(select count(*) as total_fm from
(select * from likes WHERE user_id in 
(
select user_id from  profiles where gender ='f'
)) as fm)

-


(select count(*) as total_m from
(select * from likes WHERE user_id in 
(
select user_id from  profiles where gender ='m'
)) as m) as fm_more_then_m_on;



























