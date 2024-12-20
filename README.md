# IMDB

# IMDb Movie Database Analysis

## Project Overview
This project involves the analysis of the IMDb movie database, focusing on various aspects like movie release trends, production statistics, genre analysis, ratings, and crew information. The goal is to extract valuable insights related to movie trends, production house performance, and movie ratings that could help stakeholders in the film industry make informed decisions.

## Data Source
The data used in this project is derived from the IMDb movie database, containing information about movies, ratings, genres, production companies, directors, actors, and more. The database includes tables such as `movie`, `genre`, `director_mapping`, `role_mapping`, `names`, and `ratings`.

## Installation & Setup
To get started, follow these steps:

1. Clone the repository:
    ```bash
    git clone https://github.com/gowthamee18/IMDB
    ```

2. Install necessary dependencies:
    ```bash
    pip install -r requirements.txt
    ```

3. Set up the database:
    - If you're using a local database, make sure to configure the database connection in the `config` file.

4. Run the analysis script:
    ```bash
    python analysis.py
    ```
## Project Structure

The project is organized as follows:

- **data/**  
  Contains raw data files.

- **analysis.py**  
  Python script to analyze the IMDb database.

- **queries/**  
  Directory for SQL queries used in the analysis.

- **requirements.txt**  
  File listing the required Python dependencies.

- **README.md**  
  Project documentation.

- **config.py**  
  Configuration file for database connection.

## Analysis & Insights
### Key Findings:
- **Most Popular Genre:** Drama is the genre with the highest number of movies produced, followed by Thriller and Comedy.
- **Trends in Movie Releases:** A majority of movies are released in the months of September, October, and November, with 2017 seeing the highest number of releases (3052 movies).
- **Top Directors & Actors:** Directors like Balavalli Darshith Bhat and Srinivas Gundareddy have produced some of the highest-rated movies. Actors like Aamir Qureshi and Aarav Mavi lead with a 10.0 median rating.
- **Production House Performance:** Dream Warrior Picture is the top production house based on the number of movies with an average rating above 8.

## Queries
### Sample SQL Queries Used:
- **Query to find the total number of rows in each table:**
    ```sql
    SELECT COUNT(*) FROM movie;
    ```
- **Query to determine the number of movies released in the USA or India in 2019:**
    ```sql
    SELECT COUNT(*) FROM movie WHERE (country = 'USA' OR country = 'India') AND year = 2019;
    ```
- **Query to calculate the average movie duration by genre:**
    ```sql
    SELECT genre, AVG(duration) 
    FROM movie 
    JOIN genre ON movie.id = genre.movie_id 
    GROUP BY genre;
    ```

## Recommendations
Based on the analysis, here are some recommendations for movie production companies:
- **Focus on Thrillers:** Thriller is a popular genre with a substantial number of high-rated movies. Producing more content in this genre could attract larger audiences.
- **Increase Multi-Genre Production:** Movies that belong to more than one genre tend to perform better. Producers should consider blending multiple genres in their projects.
- **Leverage High-Rated Directors:** Directors like Srinivas Gundareddy, who consistently deliver highly-rated films, should be prioritized for future projects.

