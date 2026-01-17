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


Step 0: Create staging table to preserve raw data
CREATE TABLE layoffs_stagging LIKE layoffs;

-- Insert all raw data into staging
INSERT INTO layoffs_stagging
SELECT * FROM layoffs;

-- Preview staging table
SELECT * FROM layoffs_stagging;

--

