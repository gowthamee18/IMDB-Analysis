
# IMDb Movie Database Analysis

This document provides an overview of queries performed on the IMDb database. The database contains comprehensive details about movies, genres, directors, actors, ratings, and production companies.

## Database Overview

### Tables:
1. **movie**: Details like `id`, `title`, `year`, `duration`, `country`, `languages`, `production_company`, `worldwide_gross_income`.
2. **genre**: Links movies to genres (`movie_id`, `genre`).
3. **director_mapping**: Maps movies to directors (`movie_id`, `name_id`).
4. **role_mapping**: Maps movies to actors/actresses and their roles (`movie_id`, `name_id`).
5. **names**: Details about people (`id`, `name`, `date_of_birth`, `known_for_movies`).
6. **ratings**: Movie ratings including `avg_rating`, `total_votes`, `median_rating`.

---

## Query Highlights

### Basic Statistics
1. **Row Counts**: `SELECT COUNT(*) AS total_rows FROM movie;`
2. **Nullable Columns**: Identify nullable columns in a table.
   ```sql
   SELECT column_name
   FROM information_schema.columns
   WHERE table_name = 'movie' AND is_nullable = 'YES';
   ```

### Movie Analysis
1. **Release Trends**: Count movies released per year/month.
   ```sql
   GROUP BY release_year, release_month;
   ```
2. **Country-Specific Movie Count**: Movies in USA/India in 2019.
   ```sql
   WHERE (country = 'USA' OR country = 'India') AND year = 2019;
   ```
3. **Single Genre Movies**: Count movies with one genre.
   ```sql
   HAVING COUNT(*) = 1;
   ```
4. **Average Duration by Genre**: Calculate average duration.
   ```sql
   AVG(duration) AS average_duration;
   ```

### Ratings Analysis
1. **Rating Extremes**: Minimum and maximum ratings.
   ```sql
   SELECT MIN(avg_rating), MAX(avg_rating) FROM ratings;
   ```
2. **Top Rated Movies**: Top 10 movies by `avg_rating`.
   ```sql
   ORDER BY avg_rating DESC LIMIT 10;
   ```
3. **Median Rating Distribution**: Group movies by `median_rating`.
   ```sql
   GROUP BY median_rating;
   ```

### Production Company Insights
1. **Most Hits**: Companies with most hits (`avg_rating > 8`).
   ```sql
   GROUP BY production_company ORDER BY hit_movie_count DESC;
   ```
2. **Total Votes**: Sum of votes by production company.
   ```sql
   SUM(ratings.total_votes) AS total_votes;
   ```

### Actor and Director Analysis
1. **Top Actors by Ratings**: Best-rated actors.
   ```sql
   WHERE country = 'India' AND role_mapping.category = 'actor';
   ```
2. **Top Directors**: Directors with the most movies.
   ```sql
   GROUP BY name ORDER BY movie_count DESC;
   ```

### Advanced Queries
1. **Rating Category**: Classify movies by `avg_rating`.
   ```sql
   CASE WHEN ratings.avg_rating >= 8.5 THEN 'Excellent';
   ```
2. **Top Genres**: Popular genres and movies.
   ```sql
   RANK() OVER (ORDER BY COUNT(*) DESC);
   ```
3. **Moving Average**: Calculate cumulative durations.
   ```sql
   SUM(movie.duration) OVER (PARTITION BY genre ORDER BY year);
   ```

### Correlations and Trends
1. **Hindi Movie Stats**: Compare Hindi movies vs others.
   ```sql
   AVG(CASE WHEN languages LIKE '%Hindi%' THEN duration END);
   ```
2. **Correlation Analysis**: Correlate `total_votes` and `avg_rating`.
   ```sql
   SUM((votes - avg_votes) * (rating - avg_rating)) / COUNT(*);
   ```

### Production Analysis
1. **Top Grossing Movies**: Top 5 grossing movies by year and genre.
   ```sql
   ROW_NUMBER() OVER (PARTITION BY year, genre ORDER BY worldwide_gross_income DESC);
   ```
2. **Consistent High Ratings**: Companies with 3+ high-rated movies (2017-2019).
   ```sql
   HAVING COUNT(*) = 3;
   ```

---

## Key Techniques Used
- **Aggregate Functions**: `COUNT`, `AVG`, `SUM`, `MIN`, `MAX`
- **Window Functions**: `RANK`, `ROW_NUMBER`, `SUM() OVER`
- **Joins**: Combine related tables for insights.
- **Subqueries**: Extract subsets of data.
- **Conditional Aggregates**: `CASE` and `HAVING` for filtering.

---

Use these queries to analyze and derive insights from the IMDb database effectively!
