SELECT * FROM artist;
SELECT * FROM canvas_size;
SELECT * FROM image_link;
SELECT * FROM museum;
SELECT * FROM museum_hours;	
SELECT * FROM product_size;
SELECT * FROM subject;
SELECT * FROM work;


# Which museums are open on Mondays? Display museum name and city:

SELECT m.name as museum_name, m.city
FROM museum_hours mh
join museum m on m.museum_id = mh.museum_id
WHERE day = 'Monday';


# Find museums located in the US:

SELECT name, city
FROM museum
WHERE country = 'USA'
ORDER BY city, name;

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

# What are the 3 most most expensive paintings at regular price?

SELECT
    product_size.regular_price,
    work.name AS name_of_painting,
    artist.full_name AS artist_name
FROM product_size
JOIN work ON product_size.work_id = work.work_id
JOIN artist ON work.artist_id = artist.artist_id
ORDER BY product_size.regular_price DESC
LIMIT 3;

# What are the most popluar painting subjects:

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

# Which artists are represented? Include nationality, birth and painting style:

SELECT full_name, nationality, birth, style
FROM artist
ORDER BY nationality, style;

# What are the 5 the most common styles among the artists?

SELECT DISTINCT style, count(*)
FROM artist 
group by style
ORDER BY count(*) DESC
LIMIT 5;

# Find total artists of each painting style and order by total artist pr. style, nationality and last name:

SELECT full_name, nationality, style
, count(style) over (PARTITION BY style) AS Total_Style
FROM artist
ORDER BY Total_Style DESC, nationality, full_name DESC; 

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
  

# Find work name, artist and style of paintings above 7000. Show max size for each painting:

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



# Find artist name, work name, sales price and museum name of pictures with size_id between 2000-2500:
  
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
WHERE product_size.size_id > 2000 AND product_size.size_id < 2500;

# Find total artists of each painting style, and order by total artists pr style, nationality and last name:

SELECT full_name, nationality, style
, count(style) over (PARTITION BY style) AS Total_Style
FROM artist
ORDER BY Total_Style DESC, nationality, full_name DESC; 
