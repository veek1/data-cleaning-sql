-- ======================================
-- Exploratory Data Analysis (EDA)
-- Dataset: layoffs_stagging2
-- Purpose: Identify patterns, trends, and key insights
-- ======================================


-- --------------------------------------
-- 1. Overview of the cleaned dataset
-- --------------------------------------
SELECT *
FROM layoffs_stagging2;
-- Confirms final dataset structure and values


-- --------------------------------------
-- 2. Largest single layoff events
-- --------------------------------------
SELECT 
    MAX(total_laid_off) AS max_total_laid_off,
    MAX(percentage_laid_off) AS max_percentage_laid_off
FROM layoffs_stagging2;
-- Identifies extreme layoff events


-- --------------------------------------
-- 3. Companies with 100% layoffs
-- --------------------------------------
SELECT 
    company,
    location,
    total_laid_off,
    percentage_laid_off,
    `date`
FROM layoffs_stagging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;
-- Companies that fully shut down or exited


-- --------------------------------------
-- 4. Total layoffs by company
-- --------------------------------------
SELECT 
    company,
    SUM(total_laid_off) AS total_layoffs
FROM layoffs_stagging2
GROUP BY company
ORDER BY total_layoffs DESC;
-- Identifies companies with the highest cumulative layoffs


-- --------------------------------------
-- 5. Time range of the dataset
-- --------------------------------------
SELECT 
    MIN(`date`) AS earliest_date,
    MAX(`date`) AS latest_date
FROM layoffs_stagging2;
-- Confirms time span of the data


-- --------------------------------------
-- 6. Layoffs by industry
-- --------------------------------------
SELECT 
    industry,
    SUM(total_laid_off) AS total_layoffs
FROM layoffs_stagging2
GROUP BY industry
ORDER BY total_layoffs DESC;
-- Shows which industries were most impacted


-- --------------------------------------
-- 7. Layoffs by country
-- --------------------------------------
SELECT 
    country,
    SUM(total_laid_off) AS total_layoffs
FROM layoffs_stagging2
GROUP BY country
ORDER BY total_layoffs DESC;
-- Highlights geographic impact of layoffs


-- --------------------------------------
-- 8. Layoffs by company stage
-- --------------------------------------
SELECT 
    stage,
    SUM(total_laid_off) AS total_layoffs
FROM layoffs_stagging2
GROUP BY stage
ORDER BY total_layoffs DESC;
-- Insight into which company stages were most affected


-- --------------------------------------
-- 9. Yearly layoff trend
-- --------------------------------------
SELECT 
    YEAR(`date`) AS year,
    SUM(total_laid_off) AS total_layoffs
FROM layoffs_stagging2
GROUP BY YEAR(`date`)
ORDER BY year ASC;
-- Shows how layoffs changed year over year


-- --------------------------------------
-- 10. Monthly layoffs trend
-- --------------------------------------
SELECT 
    DATE_FORMAT(`date`, '%Y-%m') AS month,
    SUM(total_laid_off) AS total_layoffs
FROM layoffs_stagging2
GROUP BY month
ORDER BY month ASC;
-- Identifies spikes and declines over time


-- --------------------------------------
-- 11. Rolling (cumulative) layoffs over time
-- --------------------------------------
WITH monthly_layoffs AS (
    SELECT 
        DATE_FORMAT(`date`, '%Y-%m') AS month,
        SUM(total_laid_off) AS total_layoffs
    FROM layoffs_stagging2
    GROUP BY month
)
SELECT 
    month,
    total_layoffs,
    SUM(total_layoffs) OVER (ORDER BY month) AS rolling_total_layoffs
FROM monthly_layoffs
ORDER BY month;
-- Shows how layoffs accumulate over time


-- --------------------------------------
-- 12. Average layoffs per event by industry
-- --------------------------------------
SELECT 
    industry,
    ROUND(AVG(total_laid_off), 0) AS avg_layoffs_per_event
FROM layoffs_stagging2
GROUP BY industry
ORDER BY avg_layoffs_per_event DESC;
-- Identifies industries with larger average layoff events


-- --------------------------------------
-- 13. Companies with multiple layoff events
-- --------------------------------------
SELECT 
    company,
    COUNT(*) AS number_of_layoff_events,
    SUM(total_laid_off) AS total_layoffs
FROM layoffs_stagging2
GROUP BY company
HAVING COUNT(*) > 1
ORDER BY total_layoffs DESC;
-- Highlights companies that conducted repeated layoffs
