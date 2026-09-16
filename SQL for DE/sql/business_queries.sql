-- CropGuide SQL Practice

-- BASIC SELECT
SELECT * FROM farmers;

SELECT name, country, crop
FROM farmers;

-- FILTERING
SELECT farmer_id, name, state, crop
FROM farmers
WHERE country = 'Nigeria';

SELECT name, country, crop
FROM farmers
WHERE crop LIKE '%Tomato%';

SELECT name, country, farm_size_hectares
FROM farmers
WHERE farm_size_hectares >= 10
ORDER BY farm_size_hectares DESC;

SELECT name, country, crop
FROM farmers
WHERE country IN ('Nigeria', 'Ghana');

SELECT name, farm_size_hectares
FROM farmers
WHERE farm_size_hectares BETWEEN 2 AND 5
ORDER BY farm_size_hectares;

-- AGGREGATION
SELECT country, COUNT(*) AS farmer_count
FROM farmers
GROUP BY country
ORDER BY farmer_count DESC;

SELECT country, ROUND(AVG(farm_size_hectares), 2) AS avg_farm_size
FROM farmers
GROUP BY country;

SELECT crop, COUNT(*) AS farmer_count
FROM farmers
GROUP BY crop
HAVING COUNT(*) >= 15
ORDER BY farmer_count DESC;

-- JOINS
SELECT
    f.name,
    f.country,
    c.crop_name,
    fr.season_year,
    fr.yield_tonnes
FROM farmers f
JOIN farm_records fr ON f.farmer_id = fr.farmer_id
JOIN crops c ON fr.crop_id = c.crop_id
ORDER BY fr.season_year DESC, fr.yield_tonnes DESC;

SELECT
    c.crop_name,
    ROUND(AVG(fr.yield_tonnes), 2) AS avg_yield_tonnes
FROM farm_records fr
JOIN crops c ON fr.crop_id = c.crop_id
GROUP BY c.crop_name
ORDER BY avg_yield_tonnes DESC;

-- BUSINESS QUESTIONS

-- Which crops show the highest disease rate?
SELECT
    c.crop_name,
    COUNT(*) AS total_records,
    SUM(fr.disease_reported) AS disease_cases,
    ROUND(100.0 * SUM(fr.disease_reported) / COUNT(*), 1) AS disease_rate_pct
FROM farm_records fr
JOIN crops c ON fr.crop_id = c.crop_id
GROUP BY c.crop_name
ORDER BY disease_rate_pct DESC;

-- Does irrigation appear to affect yield?
SELECT
    irrigation_used,
    ROUND(AVG(yield_tonnes), 2) AS avg_yield_tonnes,
    COUNT(*) AS records
FROM farm_records
GROUP BY irrigation_used;

-- Which crops are most expensive on average in Nigeria?
SELECT
    c.crop_name,
    ROUND(AVG(mp.price_per_kg), 2) AS avg_price_per_kg,
    mp.currency
FROM market_prices mp
JOIN crops c ON mp.crop_id = c.crop_id
WHERE mp.country = 'Nigeria'
GROUP BY c.crop_name, mp.currency
ORDER BY avg_price_per_kg DESC;

-- Compare average Maize prices across countries
SELECT
    mp.country,
    ROUND(AVG(mp.price_per_kg), 2) AS avg_price,
    mp.currency
FROM market_prices mp
JOIN crops c ON mp.crop_id = c.crop_id
WHERE c.crop_name = 'Maize'
GROUP BY mp.country, mp.currency;

-- Which states receive the most rainfall?
SELECT
    country,
    state,
    ROUND(AVG(rainfall_mm), 2) AS avg_rainfall_mm,
    ROUND(AVG(avg_temp_c), 2) AS avg_temp_c
FROM weather_readings
GROUP BY country, state
ORDER BY avg_rainfall_mm DESC;

-- Which crops have high disease rates but still strong yields?
SELECT
    c.crop_name,
    ROUND(AVG(fr.yield_tonnes), 2) AS avg_yield,
    ROUND(100.0 * SUM(fr.disease_reported) / COUNT(*), 1) AS disease_rate_pct
FROM farm_records fr
JOIN crops c ON fr.crop_id = c.crop_id
GROUP BY c.crop_name
HAVING COUNT(*) >= 20
ORDER BY disease_rate_pct DESC, avg_yield DESC;

-- Which countries have the largest farms on average?
SELECT
    country,
    ROUND(AVG(farm_size_hectares),2) AS avg_farm_size,
    COUNT(*) AS farmer_count
FROM farmers
GROUP BY country
ORDER BY avg_farm_size DESC;

-- Which farmers harvested more than 20 tonnes?
SELECT
    f.name,
    f.country,
    c.crop_name,
    fr.yield_tonnes,
    fr.harvest_date
FROM farmers f
JOIN farm_records fr ON f.farmer_id = fr.farmer_id
JOIN crops c ON fr.crop_id = c.crop_id
WHERE fr.status = 'Harvested'
  AND fr.yield_tonnes > 20
ORDER BY fr.yield_tonnes DESC;
