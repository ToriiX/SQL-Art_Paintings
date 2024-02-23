SELECT * FROM artist;
SELECT * FROM canvas_size;
SELECT * FROM image_link;
SELECT * FROM museum;
SELECT * FROM museum_hours;	
SELECT * FROM product_size;
SELECT * FROM subject;
SELECT * FROM work;

# Painted subjects, styles, prices, represented work and artists: 

# What are the most popluar painting subjects?

SELECT DISTINCT subject, count(*) 
FROM subject 
JOIN work ON subject.work_id = work.work_id
group by subject
ORDER BY count(*) DESC
LIMIT 10;

# What are the least painted subjects?

SELECT DISTINCT subject, count(*) 
FROM subject 
JOIN work ON subject.work_id = work.work_id
group by subject
ORDER BY count(*)
LIMIT 5;


# What are the 5 the most common styles among the represented artists?

SELECT DISTINCT style, count(*)
FROM artist 
group by style
ORDER BY count(*) DESC
LIMIT 5;


# Find total artists of each painting style, and order by total artists pr style, nationality and last name:

SELECT full_name, nationality, style
, count(style) over (PARTITION BY style) AS Total_Style
FROM artist
ORDER BY Total_Style DESC, nationality, full_name; 


# Find represented artists and total artists of each painting style and order by total artist pr. style, nationality and last name:

SELECT full_name, nationality, style
, count(style) over (PARTITION BY style) AS Total_Style
FROM artist
ORDER BY Total_Style DESC, nationality, full_name; 
  

# Find name of picture, artist and style of big paintings above size_id 7000. Show max size for each painting. Include name of artist, painting and style:

SELECT 
    MAX(product_size.size_id) AS Max_size_painting,
    work.name AS work_name,
    work.style,
    artist.full_name as Artist_name
FROM product_size 
JOIN work ON product_size.work_id = work.work_id
JOIN artist ON work.artist_id = artist.artist_id
GROUP BY work.name, artist.full_name, work.style
HAVING MAX(product_size.size_id) >= 7000;



# Find artist name, name of picture, sales price and museum name of pictures with size_id between 2000-2500. Include name of artist, piture, size, sales price and museum:
  
SELECT
    artist.full_name AS artist_name,
    work.name AS work_name,
    product_size.size_id,
    product_size.sale_price,
    museum.name AS museum_name
FROM product_size
JOIN work ON product_size.work_id = work.work_id
JOIN artist ON work.artist_id = artist.artist_id
JOIN museum ON work.museum_id = museum.museum_id
WHERE product_size.size_id >= 2000 AND product_size.size_id <= 2500;


# Which paintings are sold for more than the regular price?

SELECT COUNT(*) AS n_paintings
FROM product_size
WHERE sale_price > regular_price;

# Which paintings have a sales price half of regular price?

SELECT name AS painting_name, sale_price, regular_price
, (regular_price * 0.50) AS regular_50_perc
FROM product_size 
JOIN work 
  ON product_size.work_id = work.work_id
WHERE sale_price < regular_price * 0.50;

# What are the 10 most most expensive paintings at regular price? Include style and name of artist

SELECT
    product_size.regular_price,
    work.name AS name_of_painting,
    work.style,
    subject.subject,
    artist.full_name AS artist_name
FROM product_size
JOIN work ON product_size.work_id = work.work_id
JOIN artist ON work.artist_id = artist.artist_id
JOIN subject ON WORK.work_id = subject.work_id
ORDER BY product_size.regular_price DESC
LIMIT 10;

# What are the 5 most expensive subjects on average?

SELECT
	subject.subject,
	AVG(product_size.regular_price) AS average_price
    FROM subject
    JOIN product_size ON subject.work_id = product_size.work_id
    GROUP BY subject.subject
    ORDER BY average_price DESC;

# What are the 5 most extensive painting styles on average?
    
SELECT
	work.style,
	AVG(product_size.regular_price) AS average_price
    FROM work
    JOIN product_size ON work.work_id = product_size.work_id
    GROUP BY work.style
    ORDER BY average_price DESC
    LIMIT 5;
    
# US:

# Find museums located in the US:

SELECT name, city
FROM museum
WHERE country = 'USA'
ORDER BY city, name;


# Which museums in the US are open on Mondays? Display museum name and city:

SELECT m.name as museum_name, m.city
FROM museum_hours mh
join museum m on m.museum_id = mh.museum_id
WHERE day = 'Monday' and country = 'USA'
ORDER BY city;

# Which American artists are represented? Include nationality, birth and painting style:

SELECT full_name, nationality, birth, style
FROM artist
WHERE nationality = 'American'
ORDER BY nationality, style;


# Which artists and pictures are represented in museums in the US? Include artist, nationality, museum and city where museum is located:

SELECT 
    artist.full_name,
    artist.nationality,
    museum.name,
    museum.city,
    museum.country
FROM artist
JOIN work ON artist.artist_id = work.artist_id
JOIN museum ON museum.museum_id = work.museum_id
WHERE museum.country = 'USA'
ORDER BY city, name, nationality, full_name;

# Which 5 painting styles are most represented in the US museums?

SELECT 
    work.style,
    COUNT(work.style) AS style_count
FROM work
JOIN museum ON work.museum_id = museum.museum_id
WHERE museum.country = 'USA'
GROUP BY work.style
ORDER BY style_count DESC
LIMIT 5;