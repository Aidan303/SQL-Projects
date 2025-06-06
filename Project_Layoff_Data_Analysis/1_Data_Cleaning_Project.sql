-- Data Cleaning Project

SELECT  *
FROM layoffs;

-- 1. Remove duplicates
-- 2. Standardize the data
-- 3. Null Values or blank values
-- 4. Remove unnecessary Columns or rows


-- Create data staging table
CREATE TABLE layoffs_staging
LIKE layoffs;

-- Inspect staging table columns
SELECT *
FROM layoffs_staging;

-- Insert data into staging table
INSERT layoffs_staging
SELECT *
FROM layoffs;


-- Removing Duplicates
SELECT *
FROM layoffs_staging;

-- Creating CTE with row numbers to identify duplicate rows
WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

-- Creating additional table with row numbers as seen in CTE (can't delete directly from a cte)

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2;

-- Inserting CTE data into the second staging table
INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

-- Deleting duplicate rows from the second staging table
DELETE
FROM layoffs_staging2
WHERE row_num > 1;

SELECT *
FROM layoffs_staging2;


-- Standardizing data

-- Triming white space from company names
SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

-- Finding non standardized industry labels (ie. crypto, cryptocurrency, crypto currency)
SELECT DISTINCT(industry)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry = 'Crypto Currency' OR industry = 'CryptoCurrency';

-- could also use
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- Standardizing locations
SELECT DISTINCT(location)
FROM layoffs_staging2
ORDER BY 1;

-- Standardizing country
SELECT DISTINCT(country)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = 'United States'
WHERE country LIKE 'United States%';

-- Date column data type change

SELECT 	`date`,
str_to_date(`date`, '%m/%d/%Y')
FROM layoffs_staging2;

-- Change each row
UPDATE layoffs_staging2
SET `date` = str_to_date(`date`, '%m/%d/%Y');

SELECT `date`
FROM layoffs_staging2;

-- Change data type of column in table
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;


-- Remove/Populate null and blank values

-- Find records where both total_laid_off and percentage_laid_off are null
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Finding presence of blank and null industry values
SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';

SELECT DISTINCT(industry)
FROM layoffs_staging2;

-- Update rows where a non null or blank industry exists for another record of the same company

-- Set all blank industry values to null
UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

-- Find all records where a company has a null or blank industry in one record, and a value in another record
SELECT *
FROM layoffs_staging2 st1
JOIN layoffs_staging2 st2
	ON st1.company = st2.company
	AND st1.location = st2.location
WHERE (st1.industry IS NULL OR st1.industry = '')
AND st2.industry IS NOT NULL;

-- Change all records with null industry values to the value found in a non null industry record of the same company
UPDATE layoffs_staging2 st1
JOIN layoffs_staging2 st2
	ON st1.company = st2.company
    AND st1.location = st2.location
SET st1.industry = st2.industry
WHERE (st1.industry IS NULL OR st1.industry = '')
AND st2.industry IS NOT NULL;


-- Remove columns and rows 

-- Remove rows with null or blank values in both total_laid_off and percentage_laid_off

SELECT *
FROM layoffs_staging2
WHERE (total_laid_off IS NULL OR total_laid_off = '')
AND (percentage_laid_off IS NULL OR percentage_laid_off = '');

DELETE
FROM layoffs_staging2
WHERE (total_laid_off IS NULL OR total_laid_off = '')
AND (percentage_laid_off IS NULL OR percentage_laid_off = '');

-- Delete unecessary columns

SELECT *
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;



