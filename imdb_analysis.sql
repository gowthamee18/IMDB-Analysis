use imdb;
/*  The database contains the following tables:

1. movie: This table stores information about movies. It has a primary key `id` and columns such as `title`, `year`, `date_published`, `duration`, `country`, `worlwide_gross_income`, `languages`, and `production_company`.
2. genre: This table represents the genres of movies. It has a composite primary key `(movie_id, genre)` and contains the movie ID and genre for each movie.
3. director_mapping: This table maps movies to directors. It has a composite primary key `(movie_id, name_id)` and contains the movie ID and director name for each movie.
4. role_mapping: This table maps movies to actors/actresses and their roles. It has a composite primary key `(movie_id, name_id)` and contains the movie ID, actor/actress name, and role category for each movie.
5. names: This table stores information about people involved in movies, such as actors, actresses, and directors. It has a primary key `id` and columns like `name`, `height`, `date_of_birth`, and `known_for_movies`.
6. ratings: This table contains ratings information for movies. It has a primary key `movie_id` and columns such as `avg_rating`, `total_votes`, and `median_rating`.
These tables are connected to each other using foreign keys. 
The `movie_id` column in the genre, director_mapping, and role_mapping tables references the `id` column in the movie table. 
The `name_id` column in the director_mapping and role_mapping tables references the `id` column in the names table. 
These relationships allow for the association of movies with genres, directors, and actors/actresses.
*/

SELECT COUNT(*) AS total_rows FROM movie;   --- 7997 rows
SELECT COUNT(*) AS total_rows FROM genre;   --- 14662 rows
SELECT COUNT(*) AS total_rows FROM director_mapping; --- 3867 rows 
SELECT COUNT(*) AS total_rows FROM role_mapping; --- 15615 rows
SELECT COUNT(*) AS total_rows FROM names;  --- 25735 rows
SELECT COUNT(*) AS total_rows FROM ratings; --- 7997 rows

SELECT 
    column_name
FROM information_schema.columns
WHERE table_name = 'movie'
    AND is_nullable = 'YES';
    
SELECT 
    YEAR(date_published) AS release_year,
    MONTH(date_published) AS release_month,
    COUNT(*) AS movie_count
FROM
    movie
GROUP BY
    release_year, release_month
ORDER BY
    release_year, release_month;

SELECT 
    COUNT(*) AS movie_count
FROM
    movie
WHERE
    (country = 'USA' OR country = 'India')
    AND year = 2019;

SELECT DISTINCT genre
FROM genre;

SELECT genre, COUNT(*) AS movie_count
FROM genre
GROUP BY genre
ORDER BY movie_count DESC
LIMIT 1;

SELECT COUNT(*) AS movie_count
FROM (
    SELECT movie_id
    FROM genre
    GROUP BY movie_id
    HAVING COUNT(*) = 1
) AS single_genre_movies;


SELECT genre, AVG(duration) AS average_duration
FROM movie
JOIN genre ON movie.id = genre.movie_id
GROUP BY genre;

SELECT genre, movie_count, genre_rank
FROM (
    SELECT genre, COUNT(*) AS movie_count,
           RANK() OVER (ORDER BY COUNT(*) DESC) AS genre_rank
    FROM genre
    GROUP BY genre
) AS genre_counts
WHERE genre = 'thriller';

SELECT MIN(avg_rating) AS min_avg_rating, MAX(avg_rating) AS max_avg_rating,
       MIN(total_votes) AS min_total_votes, MAX(total_votes) AS max_total_votes,
       MIN(median_rating) AS min_median_rating, MAX(median_rating) AS max_median_rating
FROM ratings;

SELECT id, title, avg_rating
FROM movie
INNER JOIN ratings ON movie.id = ratings.movie_id
ORDER BY avg_rating DESC
LIMIT 10;

SELECT median_rating, COUNT(movie_id) AS movie_count
FROM ratings
GROUP BY median_rating;

SELECT COUNT(movie.id) AS hit_movie_count, movie.production_company, AVG(ratings.avg_rating) AS average_rating
FROM movie
INNER JOIN ratings ON movie.id = ratings.movie_id
WHERE ratings.avg_rating > 8 AND movie.production_company IS NOT NULL
GROUP BY movie.production_company
ORDER BY hit_movie_count DESC
Limit 1;

SELECT genre.genre, COUNT(movie.id) AS movie_count
FROM movie
JOIN genre ON movie.id = genre.movie_id
JOIN ratings ON movie.id = ratings.movie_id
WHERE movie.country = 'USA'
  AND YEAR(movie.date_published) = 2017
  AND MONTH(movie.date_published) = 3
  AND ratings.total_votes > 1000
GROUP BY genre.genre
ORDER BY movie_count DESC;

SELECT COUNT(g.movie_id) AS movie_count, g.genre
FROM genre g
INNER JOIN (
    SELECT m.id
    FROM movie m
    INNER JOIN ratings r ON m.id = r.movie_id
    WHERE r.avg_rating > 8 AND m.title LIKE 'The%'
) AS sub ON g.movie_id = sub.id
GROUP BY g.genre;

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'names' 
AND IS_NULLABLE = 'YES';

SELECT genre.genre AS top_genre, AVG(ratings.avg_rating) AS highest_rated, names.name AS director_name
FROM movie
INNER JOIN ratings ON movie.id = ratings.movie_id
INNER JOIN genre ON genre.movie_id = movie.id
INNER JOIN director_mapping ON movie.id = director_mapping.movie_id
INNER JOIN names ON names.id = director_mapping.name_id
WHERE ratings.avg_rating > 8
GROUP BY top_genre, director_name
ORDER BY highest_rated DESC
LIMIT 3;

SELECT names.name AS actor_name, AVG(ratings.median_rating) AS average_median_rating
FROM names
INNER JOIN role_mapping ON names.id = role_mapping.name_id
INNER JOIN ratings ON role_mapping.movie_id = ratings.movie_id
GROUP BY actor_name
HAVING AVG(ratings.median_rating) >= 8
ORDER BY average_median_rating DESC
LIMIT 2;

SELECT movie.production_company, SUM(ratings.total_votes) AS total_votes
FROM movie
INNER JOIN ratings ON movie.id = ratings.movie_id
GROUP BY movie.production_company
ORDER BY total_votes DESC
LIMIT 3;

SELECT names.name AS actor_name, AVG(ratings.avg_rating) AS average_rating
FROM movie
INNER JOIN role_mapping ON movie.id = role_mapping.movie_id
INNER JOIN names ON role_mapping.name_id = names.id
INNER JOIN ratings ON movie.id = ratings.movie_id
WHERE movie.country = 'India' AND role_mapping.category = 'actor'
GROUP BY names.name
ORDER BY average_rating DESC;

SELECT names.name AS actress_name, AVG(ratings.avg_rating) AS average_rating
FROM movie
INNER JOIN role_mapping ON movie.id = role_mapping.movie_id
INNER JOIN names ON role_mapping.name_id = names.id
INNER JOIN ratings ON movie.id = ratings.movie_id
WHERE movie.country = 'India' AND movie.languages LIKE '%Hindi%' AND role_mapping.category = 'actress'
GROUP BY names.name
ORDER BY average_rating DESC
LIMIT 5;

SELECT
    movie.title AS movie_title,
    ratings.avg_rating AS average_rating,
    CASE
        WHEN ratings.avg_rating >= 8.5 THEN 'Excellent'
        WHEN ratings.avg_rating >= 7.5 THEN 'Very Good'
        WHEN ratings.avg_rating >= 6.5 THEN 'Good'
        ELSE 'Average or Below'
    END AS rating_category
FROM
    movie
    INNER JOIN genre ON movie.id = genre.movie_id
    INNER JOIN ratings ON movie.id = ratings.movie_id
WHERE
    genre.genre = 'Thriller'
ORDER BY
    ratings.avg_rating DESC;

SELECT
    genre.genre AS movie_genre,
    movie.duration AS movie_duration,
    SUM(movie.duration) OVER (PARTITION BY genre.genre ORDER BY movie.year) AS running_total,
    AVG(movie.duration) OVER (PARTITION BY genre.genre ORDER BY movie.year ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS moving_average
FROM
    movie
    INNER JOIN genre ON movie.id = genre.movie_id
GROUP BY
    genre.genre, movie.duration, movie.year
ORDER BY
    genre.genre, movie.year;

WITH top_three_genres AS (
    SELECT genre, COUNT(*) AS movie_count
    FROM genre
    GROUP BY genre
    ORDER BY movie_count DESC
    LIMIT 3
),
highest_grossing_movies AS (
    SELECT m.year, m.title, m.worlwide_gross_income, g.genre,
           ROW_NUMBER() OVER (PARTITION BY m.year, g.genre ORDER BY m.worlwide_gross_income DESC) AS `rank`
    FROM movie m
    INNER JOIN genre g ON m.id = g.movie_id
    INNER JOIN top_three_genres t ON g.genre = t.genre
)
SELECT year, genre, title, worlwide_gross_income
FROM highest_grossing_movies
WHERE `rank` <= 5
ORDER BY year, genre, `rank`;

WITH hit_movies AS (
    SELECT m.production_company, COUNT(*) AS hit_count
    FROM movie m
    INNER JOIN ratings r ON m.id = r.movie_id
    WHERE r.avg_rating >= 7.0
    AND m.production_company IS NOT NULL
    GROUP BY m.production_company
),
top_production_houses AS (
    SELECT production_company, hit_count
    FROM hit_movies
    ORDER BY hit_count DESC
    LIMIT 2
)
SELECT production_company, hit_count
FROM top_production_houses;

WITH super_hit_drama_movies AS (
    SELECT m.id AS movie_id, m.title, r.avg_rating
    FROM movie m
    INNER JOIN ratings r ON m.id = r.movie_id
    INNER JOIN genre g ON m.id = g.movie_id
    WHERE r.avg_rating > 8.0
    AND g.genre = 'drama'
),
actresses AS (
    SELECT m.id AS movie_id, nm.name
    FROM movie m
    INNER JOIN role_mapping rm ON m.id = rm.movie_id
    INNER JOIN names nm ON rm.name_id = nm.id
    WHERE rm.category = 'actress'
),
actress_movie_count AS (
    SELECT a.name, COUNT(*) AS movie_count
    FROM super_hit_drama_movies s
    INNER JOIN actresses a ON s.movie_id = a.movie_id
    GROUP BY a.name
),
ranked_actresses AS (
    SELECT name, movie_count, ROW_NUMBER() OVER (ORDER BY movie_count DESC) AS `rank`
    FROM actress_movie_count
)
SELECT name, movie_count
FROM ranked_actresses
WHERE `rank` <= 3;

SELECT a.name, COUNT(*) AS movie_count
FROM movie m
INNER JOIN ratings r ON m.id = r.movie_id
INNER JOIN genre g ON m.id = g.movie_id
INNER JOIN role_mapping rm ON m.id = rm.movie_id
INNER JOIN names a ON rm.name_id = a.id
WHERE r.avg_rating > 8.0
AND g.genre = 'drama'
AND rm.category = 'actress'
GROUP BY a.name
ORDER BY movie_count DESC
LIMIT 3;

WITH director_movie_count AS (
    SELECT dm.name_id, nm.name, COUNT(*) AS movie_count
    FROM director_mapping dm
    INNER JOIN names nm ON dm.name_id = nm.id
    GROUP BY dm.name_id, nm.name
),
director_average_duration AS (
    SELECT dm.name_id, AVG(m.duration) AS average_duration
    FROM director_mapping dm
    INNER JOIN movie m ON dm.movie_id = m.id
    GROUP BY dm.name_id
),
director_total_ratings AS (
    SELECT dm.name_id, SUM(r.total_votes) AS total_votes
    FROM director_mapping dm
    INNER JOIN ratings r ON dm.movie_id = r.movie_id
    GROUP BY dm.name_id
),
ranked_directors AS (
    SELECT dmc.name_id, dmc.name, dmc.movie_count, ad.average_duration, tr.total_votes,
           ROW_NUMBER() OVER (ORDER BY dmc.movie_count DESC) AS `rank`
    FROM director_movie_count dmc
    LEFT JOIN director_average_duration ad ON dmc.name_id = ad.name_id
    LEFT JOIN director_total_ratings tr ON dmc.name_id = tr.name_id
)
SELECT name, movie_count, average_duration, total_votes
FROM ranked_directors
WHERE `rank` <= 9;

SELECT nm.name, COUNT(*) AS movie_count, AVG(m.duration) AS average_duration, SUM(r.total_votes) AS total_votes
FROM director_mapping dm
INNER JOIN names nm ON dm.name_id = nm.id
INNER JOIN movie m ON dm.movie_id = m.id
INNER JOIN ratings r ON dm.movie_id = r.movie_id
GROUP BY dm.name_id, nm.name
ORDER BY movie_count DESC
LIMIT 9;


WITH hindi_movies_average_duration AS (
    SELECT AVG(duration) AS hindi_average
    FROM movie
    WHERE languages LIKE '%Hindi%'
),
other_languages_average_duration AS (
    SELECT AVG(duration) AS other_languages_average
    FROM movie
    WHERE languages NOT LIKE '%Hindi%'
)
SELECT hindi_average, other_languages_average
FROM hindi_movies_average_duration, other_languages_average_duration;

SELECT
    AVG(CASE WHEN languages LIKE '%Hindi%' THEN duration END) AS hindi_average,
    AVG(CASE WHEN languages NOT LIKE '%Hindi%' THEN duration END) AS other_languages_average
FROM movie
WHERE duration IS NOT NULL;

WITH hindi_movie_stats AS (
    SELECT
        AVG(r.total_votes) AS avg_votes,
        AVG(r.avg_rating) AS avg_rating
    FROM movie m
    INNER JOIN ratings r ON m.id = r.movie_id
    WHERE m.languages LIKE '%Hindi%'
    AND r.total_votes IS NOT NULL
    AND r.avg_rating IS NOT NULL
)
SELECT
    avg_votes AS average_votes,
    avg_rating AS average_rating,
    (SUM((r.total_votes - avg_votes) * (r.avg_rating - avg_rating)) / COUNT(*)) /
    (SQRT(SUM(POW(r.total_votes - avg_votes, 2)) / COUNT(*)) * SQRT(SUM(POW(r.avg_rating - avg_rating, 2)) / COUNT(*))) AS correlation
FROM movie m
INNER JOIN ratings r ON m.id = r.movie_id
CROSS JOIN hindi_movie_stats;

WITH high_ratings_movies AS (
    SELECT m.production_company, r.avg_rating
    FROM movie m
    INNER JOIN ratings r ON m.id = r.movie_id
    WHERE m.date_published >= '2017-01-01' AND m.date_published <= '2019-12-31'
    AND r.avg_rating >= 8.0
    AND m.production_company IS NOT NULL
    AND r.avg_rating IS NOT NULL
),
production_house_ratings AS (
    SELECT production_company, COUNT(*) AS num_high_ratings
    FROM high_ratings_movies
    WHERE production_company IS NOT NULL
    GROUP BY production_company
),
consistent_high_ratings AS (
    SELECT production_company
    FROM production_house_ratings
    WHERE num_high_ratings = 3
    AND production_company IS NOT NULL
)
SELECT production_company
FROM consistent_high_ratings;

SELECT m.production_company
FROM movie m
INNER JOIN ratings r ON m.id = r.movie_id
WHERE m.date_published >= '2017-01-01' AND m.date_published <= '2019-12-31'
AND r.avg_rating >= 8.0
AND m.production_company IS NOT NULL
AND r.avg_rating IS NOT NULL
GROUP BY m.production_company
HAVING COUNT(*) = 3;


WITH commercially_successful_movies AS (
    SELECT m.id, m.production_company, r.avg_rating, m.worlwide_gross_income
    FROM movie m
    INNER JOIN ratings r ON m.id = r.movie_id
    WHERE m.worlwide_gross_income IS NOT NULL
    AND r.avg_rating >= 8.0
    AND m.production_company IS NOT NULL
),
director_success_counts AS (
    SELECT dm.name_id, COUNT(*) AS success_count
    FROM commercially_successful_movies csm
    INNER JOIN director_mapping dm ON csm.id = dm.movie_id
    GROUP BY dm.name_id
),
directors_commercial_ratings AS (
    SELECT dm.name_id, COUNT(*) AS total_movies, MAX(success_count) AS max_success_count
    FROM commercially_successful_movies csm
    INNER JOIN director_mapping dm ON csm.id = dm.movie_id
    INNER JOIN director_success_counts dsc ON dm.name_id = dsc.name_id
    GROUP BY dm.name_id
    HAVING COUNT(*) >= 1
    AND MAX(success_count) >= 1
    ORDER BY MAX(success_count) DESC
    LIMIT 3
)
SELECT n.name AS director_name, dcr.total_movies, dcr.max_success_count
FROM directors_commercial_ratings dcr
INNER JOIN names n ON dcr.name_id = n.id
ORDER BY dcr.max_success_count DESC;
