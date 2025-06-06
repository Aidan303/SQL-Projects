SELECT*
FROM (
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = '5'
) AS may_jobs
WHERE job_title_short = 'Data Analyst';


WITH may_jobs AS (
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = '5'
)

SELECT *
FROM may_jobs
WHERE job_title_short = 'Data Analyst';


SELECT name
FROM company_dim
WHERE company_id IN (
    SELECT company_id
    FROM job_postings_fact
    WHERE job_no_degree_mention = true
);


WITH job_count AS (
    SELECT COUNT(job_id) AS count, company_id
    FROM job_postings_fact
    GROUP BY company_id
)

SELECT company_dim.name, count
FROM job_count
LEFT JOIN company_dim
ON job_count.company_id = company_dim.company_id
ORDER BY 2 DESC;



WITH remote_job_skills AS (
        WITH remote_jobs AS (
            SELECT *
            FROM job_postings_fact
            WHERE job_work_from_home = True
            AND job_title_short = 'Data Analyst'
        )

    SELECT  skill_id, COUNT(remote_jobs.job_id) AS skill_count
    FROM skills_job_dim
    JOIN remote_jobs
    ON skills_job_dim.job_id = remote_jobs.job_id
    GROUP BY skill_id
    ORDER BY 2 DESC
)

SELECT skills, remote_job_skills.skill_id, skill_count
FROM remote_job_skills
LEFT JOIN skills_dim
ON remote_job_skills.skill_id = skills_dim.skill_id
ORDER BY 3 DESC
LIMIT 5;




SELECT *
FROM skills_job_dim
LEFT JOIN skills_dim
ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE skills_dim.skill_id = 170
LIMIT 100;



SELECT job_title_short, company_id, job_location
FROM january_jobs

UNION ALL

SELECT job_title_short, company_id, job_location
FROM february_jobs

UNION ALL

SELECT job_title_short, company_id, job_location
FROM march_jobs;



WITH q1_jobs AS (
    SELECT *
    FROM january_jobs

    UNION ALL

    SELECT *
    FROM february_jobs

    UNION ALL

    SELECT *
    FROM march_jobs
)

SELECT job_title_short, job_location, job_via, job_posted_date::DATE, salary_year_avg
FROM q1_jobs
WHERE salary_year_avg > 70000
AND job_title_short = 'Data Analyst'
ORDER BY salary_year_avg DESC;