-- =========================================================
-- Identify Potentially Inconsistent Records
-- (Age vs experience plausibility check)
-- =========================================================
SELECT *
FROM tech_jobs_salaries
WHERE age - years_experience < 19;


-- =========================================================
-- Create Clean Dataset with Plausible Records
-- =========================================================
CREATE TABLE clean_job AS
SELECT *
FROM tech_jobs_salaries
WHERE age - years_experience >= 19;


-- =========================================================
-- Add Normalized Salary Column
-- =========================================================
ALTER TABLE clean_job ADD COLUMN currency_normalized REAL;


-- =========================================================
-- Normalize Salaries to USD
-- =========================================================
UPDATE clean_job
SET currency_normalized = salary_local_currency *
  CASE currency
    WHEN 'INR' THEN 0.011
    WHEN 'USD' THEN 1
    ELSE 1
  END;


-- =========================================================
-- List All Unique Job Titles
-- =========================================================
SELECT DISTINCT job_title
FROM clean_job;


-- =========================================================
-- Job Distribution and Average Salary by Role
-- =========================================================
SELECT job_title,
       COUNT(*) AS job_count,
       AVG(currency_normalized) AS avg_salary
FROM clean_job
GROUP BY job_title
ORDER BY avg_salary DESC;


-- =========================================================
-- Job Distribution by Country
-- =========================================================
SELECT country,
       COUNT(*) AS job_count
FROM clean_job
GROUP BY country
ORDER BY country;


-- =========================================================
-- Most Common Skill Combinations
-- =========================================================
SELECT primary_skill,
       secondary_skill,
       COUNT(*) AS combination_count
FROM clean_job
GROUP BY primary_skill, secondary_skill
ORDER BY combination_count DESC;


-- =========================================================
-- Education Level vs Average Salary
-- =========================================================
SELECT education_level,
       COUNT(*) AS job_count,
       AVG(currency_normalized) AS avg_salary
FROM clean_job
GROUP BY education_level
ORDER BY avg_salary DESC;
