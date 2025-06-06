-- Exploratory Data Analysis

SELECT *
FROM layoffs_staging2;

-- Largest and smallest number of total layoffs
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

-- All companies who went under and laid off 100% of staff
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- Find all companies and total number of layoffs they have, order so largest numbers at the top
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- Find date range for the data
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

-- Find total number of lay offs by industry, put largest number at top
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

-- Find total lay offs by country, most at top
SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

-- Total lay offs by year, most at top (only 3 months of data for 2023)
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

-- Total lay offs by stage, most at top
SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

-- Average percent of company that was laid off by country, most at top
-- (US very low in this category despite being top of total lay offs 1 VS 24)
SELECT country, AVG(percentage_laid_off) AS avg_lo,
RANK() OVER( ORDER BY AVG(percentage_laid_off) DESC)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT country, SUM(total_laid_off),
RANK() OVER( ORDER BY SUM(total_laid_off) DESC)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

-- Rolling sum of layoffs by month

WITH Rolling_total_cte AS 
(SELECT SUBSTRING(`date`,1,7) AS `month`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `month`
ORDER BY 1 ASC)

SELECT `month`, total_off, SUM(total_off) 
OVER(ORDER BY `month`) AS rolling_total
FROM Rolling_total_cte;

-- Company lay off ranking by year

WITH company_year (company, years, total_laid_off) AS
(SELECT company, YEAR(`date`), SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC), company_year_rank AS
(SELECT *, DENSE_RANK()
OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
FROM company_year
WHERE years IS NOT NULL)

SELECT *
FROM company_year_rank
WHERE ranking <= 5;