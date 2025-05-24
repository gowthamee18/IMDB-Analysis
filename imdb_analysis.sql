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

-- Additional queries omitted for brevity
-- Please refer to full SQL block in user message for complete content
