/*
Question: What are the most optimal skills to learn (aka it's in high demand, and a high paying skill)
-- Identify skill sin high demand associated with high average salaries for Data Analyst roles.
-- Concentrate on remote positions with specified salaries
-- Why? Target skills that offer job security (high demand) and financial benefits (high salaries)
    offering strategic insights for career development in data analytics
*/

WITH high_demand_skills AS (
    SELECT COUNT(*) AS count_skills, skills, skills_dim.skill_id
    FROM job_postings_fact
    INNER JOIN skills_job_dim
    ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE job_title_short = 'Data Analyst'
    AND job_work_from_home = True
    AND salary_year_avg IS NOT NULL
    GROUP BY skills_dim.skill_id
), high_salary_skills AS (
    SELECT skills, ROUND(AVG(salary_year_avg), 0) AS avg_salary, skills_dim.skill_id
    FROM job_postings_fact
    INNER JOIN skills_job_dim
    ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE job_title_short = 'Data Analyst'
    AND job_work_from_home = True
    AND salary_year_avg IS NOT NULL
    GROUP BY skills_dim.skill_id
)

SELECT high_demand_skills.skills, avg_salary, count_skills
FROM high_demand_skills
INNER JOIN high_salary_skills
ON high_demand_skills.skill_id = high_salary_skills.skill_id
WHERE count_skills > 10
ORDER BY 2 DESC
LIMIT 25;

-- Alternative cleaner query

SELECT skills_dim.skill_id, skills, COUNT(skills_job_dim.job_id) AS count_skills, ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim
ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim
ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst'
AND job_work_from_home = True
AND salary_year_avg IS NOT NULL
GROUP BY skills_dim.skill_id
HAVING COUNT(skills_job_dim.job_id) > 10
ORDER BY avg_salary DESC, count_skills DESC;