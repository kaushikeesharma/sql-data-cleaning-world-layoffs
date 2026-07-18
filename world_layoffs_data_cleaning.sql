-- Data Cleaning (Project)
-- > ===========================================================
-- > Project      : SQL Data Cleaning Project
-- > Dataset      : World Layoffs Dataset
-- > Database     : MySQL
-- > Author       : Kaushikee Sharma
-- > Description  : This project demonstrates the complete data
-- >                cleaning process using SQL, including
-- >                duplicate removal, standardization,
 -- >               handling missing values, and formatting dates.
-- ===========================================================

SELECT * 
from layoffs;

-- 1. Remove Duplicates
-- 2. Standardize the Data  
-- 3. Null values or Blank Value
-- 4. Remove any columns or Rows 

-- 1. Remove Duplicates --->   Remove duplicate records to ensure each layoff event is represented only once.

-- STEP 1: Create Stagging Table

CREATE TABLE layoffs_stagging
LIKE layoffs;

SELECT *
from layoffs_stagging;

INSERT layoffs_stagging
select * 
FROM layoffs;                    -- Create a staging table as a working copy of the raw dataset.
                                 -- This preserves the original data while allowing safe data cleaning.

-- STEP 2: Remove Duplicates

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, 'date') AS row_num
FROM layoffs_stagging;

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location,
industry, total_laid_off, percentage_laid_off, 'date',
stage, country, funds_raised_millions) AS row_num
FROM layoffs_stagging
)
Select *
FROM duplicate_cte
Where row_num > 1;

Select *
FROM layoffs_stagging
Where company = 'casper'

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location,
industry, total_laid_off, percentage_laid_off, 'date',
stage, country, funds_raised_millions) AS row_num
FROM layoffs_stagging
)
DELETE 
FROM duplicate_cte
Where row_num > 1;

-- Create Stagging table 2

CREATE TABLE `layoffs_stagging2` (
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

Select *
FROM layoffs_stagging2;

INSERT INTO layoffs_stagging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location,
industry, total_laid_off, percentage_laid_off, 'date',
stage, country, funds_raised_millions) AS row_num
FROM layoffs_stagging;

Select *
FROM layoffs_stagging2
WHERE row_num > 1;

DELETE 
FROM layoffs_stagging2
WHERE row_num > 1;

Select *
FROM layoffs_stagging2;

-- STEP 3: Standardize Data

-- Standardizing Data -- It means finding issues in data and fix it.

SELECT company, TRIM(company)
FROM layoffs_stagging2;

UPDATE layoffs_stagging2
SET company = TRIM(company);

SELECT DISTINCT (industry)
FROM layoffs_stagging2
Order by 1;

SELECT DISTINCT (industry)
FROM layoffs_stagging2
Order by 1;

SELECT *
FROM layoffs_stagging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_stagging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT (location)
FROM layoffs_stagging2
Order by 1;

SELECT DISTINCT (country)
FROM layoffs_stagging2
Order by 1;

SELECT *
from layoffs_stagging2
where country like 'United States%';

SELECT DISTINCT country, TRIM(Trailing '.' from country)
from layoffs_stagging2
order by 1;

UPDATE layoffs_stagging2
SET country = TRIM(Trailing '.' from country)
WHERE country like 'United States%';

-- STEP 4: Format Date Column

SELECT `date`,                 
STR_To_DATE(`date`, '%m/%d/%Y')
from layoffs_stagging2;

SELECT `date`
from layoffs_stagging2;

-- UPDATE ...

UPDATE layoffs_stagging2
SET `date` = STR_To_DATE(`date`, '%m/%d/%Y');

-- ALTER TABLE ...

ALTER TABLE layoffs_stagging2
MODIFY COLUMN `date` DATE;

-- STEP 5: Handle NULL Values

SELECT *
from layoffs_stagging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

UPDATE layoffs_stagging2
SET industry = NULL
WHERE industry = '';

SELECT *
from layoffs_stagging2
WHERE industry IS NULL
OR industry = '';

select *
from layoffs_stagging2
where company = 'Airbnb';

SELECT *
from layoffs_stagging2 t1
JOIN layoffs_stagging2 t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
and t2.industry IS NOT NULL;

SELECT t1.industry, t2.industry
from layoffs_stagging2 t1
JOIN layoffs_stagging2 t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
and t2.industry IS NOT NULL;

-- UPDATE ...

UPDATE layoffs_stagging2 t1
JOIN layoffs_stagging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
and t2.industry IS NOT NULL;

SELECT *
from layoffs_stagging2
WHERE company = 'Airbnb';

SELECT *
from layoffs_stagging2
WHERE industry IS NULL
OR industry = '';

select *
from layoffs_stagging2
where company like 'Bally%';

-- STEP 6: Remove Unnecessary Columns

SELECT *
from layoffs_stagging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE 
from layoffs_stagging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT * 
from layoffs_stagging2;

ALTER TABLE layoffs_stagging2
DROP COLUMN row_num;



