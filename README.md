# Layoffs Data Cleaning Project

## Overview
This project demonstrates a complete SQL workflow for cleaning a raw layoffs dataset.  
It includes removing duplicates, standardizing text, cleaning country names, converting dates, and handling null values.

## Purpose
The goal of this project is to showcase data cleaning skills in SQL, preparing the dataset for meaningful analysis.

## Tools
- MySQL
- VS Code

## File Structure
- `data_cleaning.sql` → All SQL scripts for the data cleaning workflow
- `README.md` → Project overview and explanation

## Steps Performed
1. **Data Ingestion**: Created a staging table to preserve raw data
2. **Remove Duplicates**: Used ROW_NUMBER() to remove duplicate records
3. **Standardize Text**: Trimmed company names and normalized industry labels
4. **Clean Country Names**: Removed trailing periods
5. **Convert Dates**: Converted text dates to DATE format
6. **Handle Nulls**: Removed rows with missing values in key columns


