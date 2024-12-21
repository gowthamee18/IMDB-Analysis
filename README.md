# IMDB

# IMDb Movie Database Analysis

IMDB Database Query Examples

This document provides an overview of queries performed on the IMDB database. The database contains comprehensive information about movies, genres, directors, actors, ratings, and production companies. Each query demonstrates how to extract, analyze, and aggregate data from the database.

Database Overview

The database consists of the following tables:
	1.	movie
	•	Stores movie details such as id, title, year, date_published, duration, country, languages, production_company, and worlwide_gross_income.
	2.	genre
	•	Links movies to their genres using a composite key (movie_id, genre).
	3.	director_mapping
	•	Maps movies to their directors via (movie_id, name_id).
	4.	role_mapping
	•	Maps movies to actors/actresses and their roles via (movie_id, name_id).
	5.	names
	•	Contains details about people (id, name, height, date_of_birth, known_for_movies).
	6.	ratings
	•	Stores movie ratings such as avg_rating, total_votes, and median_rating.

Query Highlights

Basic Statistics
	1.	Row Counts
Retrieves total row counts for each table.
Example: SELECT COUNT(*) AS total_rows FROM movie;
	2.	Nullable Columns
Identifies nullable columns in a specific table.
Example: SELECT column_name FROM information_schema.columns WHERE table_name = 'movie' AND is_nullable = 'YES';

Movie Analysis
	1.	Release Trends
Analyzes the number of movies released per year and month.
Example: GROUP BY release_year, release_month
	2.	Country-Specific Movie Count
Counts movies released in the USA or India in 2019.
Example: WHERE (country = 'USA' OR country = 'India') AND year = 2019
	3.	Single Genre Movies
Counts movies with only one genre.
Example: HAVING COUNT(*) = 1
	4.	Average Duration by Genre
Calculates the average duration of movies for each genre.
Example: AVG(duration) AS average_duration

Ratings Analysis
	1.	Rating Extremes
Identifies the minimum and maximum avg_rating, total_votes, and median_rating.
Example: SELECT MIN(avg_rating), MAX(avg_rating) FROM ratings;
	2.	Top Rated Movies
Lists the top 10 movies based on avg_rating.
Example: ORDER BY avg_rating DESC LIMIT 10
	3.	Median Rating Distribution
Groups movies by their median_rating.
Example: GROUP BY median_rating

Production Company Insights
	1.	Most Hits by Production Company
Finds the production company with the highest number of hit movies (avg_rating > 8).
Example: GROUP BY production_company ORDER BY hit_movie_count DESC
	2.	Total Votes per Production Company
Summarizes total votes received by movies of each production company.
Example: SUM(ratings.total_votes) AS total_votes

Actor and Director Analysis
	1.	Top Actors by Ratings
Lists actors and actresses with the highest average ratings.
Example: WHERE country = 'India' AND role_mapping.category = 'actor'
	2.	Top Directors
Identifies directors with the highest number of movies and their average movie duration.
Example: GROUP BY name ORDER BY movie_count DESC

Advanced Queries
	1.	Rating Category Classification
Categorizes movies based on their avg_rating into Excellent, Very Good, Good, or Average.
Example: CASE WHEN ratings.avg_rating >= 8.5 THEN 'Excellent'
	2.	Top Genres
Finds the most popular genres and their associated movies.
Example: RANK() OVER (ORDER BY COUNT(*) DESC)
	3.	Running Total and Moving Average
Calculates cumulative durations and moving averages for movies within a genre.
Example: SUM(movie.duration) OVER (PARTITION BY genre ORDER BY year)

Correlations and Trends
	1.	Hindi Movie Stats
Compares average duration and ratings of Hindi movies versus others.
Example: AVG(CASE WHEN languages LIKE '%Hindi%' THEN duration END)
	2.	Correlation Analysis
Computes the correlation between total_votes and avg_rating for Hindi movies.
Example: SUM((votes - avg_votes) * (rating - avg_rating)) / COUNT(*)

Production Analysis
	1.	Top Grossing Movies by Year
Lists the top 5 highest-grossing movies for the top 3 genres each year.
Example: ROW_NUMBER() OVER (PARTITION BY year, genre ORDER BY worlwide_gross_income DESC)
	2.	Consistent High Ratings
Finds production companies with consistent high ratings (3+ movies rated >= 8.0 from 2017-2019).
Example: HAVING COUNT(*) = 3

Key Techniques Used
	•	Aggregate Functions: COUNT, AVG, SUM, MIN, MAX
	•	Window Functions: RANK, ROW_NUMBER, SUM() OVER, AVG() OVER
	•	Joins: Inner joins between related tables to fetch comprehensive data.
	•	Subqueries: Extract subsets of data for further analysis.
	•	Conditional Aggregates: Use of CASE and HAVING for advanced filtering.

This set of queries provides an extensive look into leveraging SQL for analyzing and deriving insights from a complex movie database.

