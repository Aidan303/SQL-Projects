/*
Question: What are the most in-demand skills for data analysts?
-- Join job posting to inner join table similar to query 2.
-- Identify the top 5 in-demand skills for a data analyst.
-- Focus on all job postings.
-- Why? Retrieves the top 5 skills with the highest demand in the job market,
    providing insight into the most valuable skills for job seekers.
*/

SELECT COUNT(*), skills
FROM job_postings_fact
INNER JOIN skills_job_dim
ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim
ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst'
AND salary_year_avg IS NOT NULL
GROUP BY skills
ORDER BY 1 DESC
LIMIT 5;



