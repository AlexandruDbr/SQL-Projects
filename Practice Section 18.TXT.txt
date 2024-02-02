-- 1. Oldest users
use ig_clone;
select * from users ORDER by created_at LIMIT 5;

-- 2. What day of the week do most people register on the app

SELECT DATE_FORMAT(created_at,'%a') as Week_day, 
	COUNT(created_at) AS total FROM USERS 
		GROUP BY DATE_FORMAT(created_at,'%a')
        ORDER BY COUNT(created_at) DESC LIMIT 2;

-- OR

SELECT 
    DAYNAME(created_at) AS day,
    COUNT(*) AS total
FROM users
GROUP BY day
ORDER BY total DESC
LIMIT 2;

-- 3. Find users who never post a photo.

SELECT username, COUNT(username) FROM users 
	LEFT JOIN photos ON users.id = photos.user_id 
		WHERE photos.id IS NULL
        GROUP BY username WITH ROLLUP;

-- 4. Find who has the most likes on instagram

SELECT 
	username,
    photo_id,
    image_url,
	COUNT(photo_id) AS nr_likes
FROM photos
INNER JOIN likes ON photos.id = likes.photo_id
INNER JOIN users ON photos.user_id = users.id
	GROUP BY photo_id
			ORDER BY nr_likes DESC
				LIMIT 1;

-- 5. How many times does the average user post?

SELECT (SELECT Count(*) FROM   photos) / (SELECT Count(*) FROM   users) AS avg; 
        
-- 6. Find the number of photos posted per user

SELECT username, COUNT(*) AS nr_photos
	FROM photos 
		INNER JOIN users ON photos.user_id = users.id
			GROUP BY username WITH ROLLUP
				ORDER BY nr_photos DESC;

-- 7. What are the top 5 most commonly used hashtags
	
	SELECT tag_name, COUNT(tag_id) AS tag_nr FROM tags 
		INNER JOIN photo_tags ON tags.id = photo_tags.tag_id
			GROUP BY tag_name
				ORDER BY tag_nr DESC
					LIMIT 5;

-- 8. Find users who have liked every single photo on the site

SELECT username, count(user_id) AS no_likes FROM users 
	JOIN likes ON users.id = likes.user_id
		GROUP BY username
        HAVING no_likes = (SELECT COUNT(*) FROM photos);
        
SELECT * FROM USERS;        
INSERT INTO users (id, username) 
	VALUES(101, 'Alexandru_Dobre')
    ,(102, 'Florica_de_la_Pascani');
    
DELIMITER $$    
    
CREATE TRIGGER must_not_follow_themselves
	BEFORE INSERT ON follows FOR EACH ROW
		BEGIN
			IF NEW.followee_id = follower_id
				THEN
					SIGNAL SQLSTATE '45000'
						SET MESSAGE_TEXT = 'Must not follow themselves';
				END IF;
			END;
	$$

DELIMITER ;           

DROP TRIGGER must_not_follow_themselves;
		
USE ig_clone;

INSERT INTO follows(follower_id, followee_id) VALUES(103,103);

EXPLAIN follows;