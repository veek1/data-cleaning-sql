-- data-cleaning-sql/          <- main project folder
├── sql/                    <- all SQL workflow files
│   ├── 00_data_ingestion.sql
│   ├── 01_remove_duplicates.sql
│   ├── 02_standardize_text.sql
│   ├── 03_clean_country.sql
│   ├── 04_convert_dates.sql
│   └── 05_handle_nulls.sql
├── documentation/          <- your notes & logs
│   └── data_cleaning_log.md
└── README.md               <- project overview

-==
-- Layoffs Data Cleaning Project
-- ======================================

-- Step 0: Data ingestion
-- Purpose: Keep the original data untouched by creating a staging table
CREATE TABLE layoffs_stagging LIKE layoffs;

-- Copy all data to staging
INSERT INTO layoffs_stagging
SELECT * FROM layoffs;

-- Preview the staging table
SELECT * FROM layoffs_stagging;
-- Result: All raw data duplicated in "layoffs_stagging"

-- ======================================
-- Step 1: Remove duplicates
-- Purpose: Remove rows that are exact duplicates to avoid inflating metrics
WITH duplicate_cte AS (
    SELECT *,
           ROW_NUMBER() OVER(
               PARTITION BY company, location, industry, total_laid_off,
               percentage_laid_off, `date`, stage, country, funds_raised_millions
           ) AS row_num
    FROM layoffs_stagging
)
SELECT * FROM duplicate_cte
WHERE row_num > 1;
-- Result: Shows duplicates, keeping the first occurrence

-- Create a new table for clean data
CREATE TABLE layoffs_stagging2 (
  company TEXT,
  location TEXT,
  industry TEXT,
  total_laid_off INT DEFAULT NULL,
  percentage_laid_off TEXT,
  `date` TEXT,
  stage TEXT,
  country TEXT,
  funds_raised_millions INT DEFAULT NULL,
  row_num INT
);

-- Insert data with row number
INSERT INTO layoffs_stagging2
SELECT *,
       ROW_NUMBER() OVER(
           PARTITION BY company, location, industry, total_laid_off,
           percentage_laid_off, `date`, stage, country, funds_raised_millions
       ) AS row_num
FROM layoffs_stagging;

-- Delete duplicates (row_num > 1)
DELETE FROM layoffs_stagging2
WHERE row_num > 1;

-- Remove helper column
ALTER TABLE layoffs_stagging2
DROP COLUMN row_num;

-- Result: "layoffs_stagging2" now contains only unique rows

-- ======================================
-- Step 2: Standardize text columns
-- Purpose: Clean company names and normalize industry labels

-- Trim spaces in company names
UPDATE layoffs_stagging2
SET company = TRIM(company);
-- Result: Clean company names

-- Standardize industry column
UPDATE layoffs_stagging2
SET industry = 'Crypto'
WHERE LOWER(REPLACE(TRIM(industry), ' ', '')) LIKE 'crypto%';
-- Result: All variations of crypto industries now labeled 'Crypto'

-- ======================================
-- Step 3: Clean country column
-- Purpose: Remove trailing periods from country names
UPDATE layoffs_stagging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';
-- Result: "United States." becomes "United States"

-- ======================================
-- Step 4: Convert date column
-- Purpose: Change text dates to DATE type for analysis
UPDATE layoffs_stagging2
SET `date` = STR_TO_DATE(TRIM(`date`), '%m/%d/%Y')
WHERE `date` IS NOT NULL;

ALTER TABLE layoffs_stagging2
MODIFY COLUMN `date` DATE;
-- Result: `date` column ready for time series analysis

-- ======================================
-- Step 5: Handle null values
-- Purpose: Remove rows with no useful data
DELETE FROM layoffs_stagging2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;
-- Result: Dataset now contains only meaningful records


