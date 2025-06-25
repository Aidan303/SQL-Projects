/*
Question: What is the financial value of a player?
-- Which top players are over paid for their value, which are under paid?
-- Are top paid players worth their value?
-- Can we make up value in the aggregate?
-- Why? Determine player value as well as ways to improve team value.
*/

-- Salary per goal scored by forwards with at least one goal

SELECT dim.player_name, stat.goals, dim.position, 
    ROUND((sal.annual_salary/goals::NUMERIC),2) goal_value
FROM normalize_prem.fact_player_stats stat
INNER JOIN normalize_prem.dim_players dim
ON stat.player_id = dim.player_id
INNER JOIN normalize_prem.fact_player_salaries sal
ON stat.player_id = sal.player_id
WHERE dim.position LIKE '%FW%'
AND stat.goals != 0
order by goal_value;

-- Salary per goal scored by midfielders with at least one goal

SELECT dim.player_name, stat.goals, dim.position, 
    ROUND((sal.annual_salary/goals::NUMERIC),2) goal_value
FROM normalize_prem.fact_player_stats stat
INNER JOIN normalize_prem.dim_players dim
ON stat.player_id = dim.player_id
INNER JOIN normalize_prem.fact_player_salaries sal
ON stat.player_id = sal.player_id
WHERE dim.position LIKE '%MF%'
AND stat.goals != 0
order by goal_value;

-- Salary per goal scored by defenders with at least one goal

SELECT dim.player_name, stat.goals, dim.position, 
    ROUND((sal.annual_salary/goals::NUMERIC),2) goal_value
FROM normalize_prem.fact_player_stats stat
INNER JOIN normalize_prem.dim_players dim
ON stat.player_id = dim.player_id
INNER JOIN normalize_prem.fact_player_salaries sal
ON stat.player_id = sal.player_id
WHERE dim.position LIKE '%DF%'
AND stat.goals != 0
order by goal_value;

-- Top goal scorers salary per goal and rank among league

SELECT RANK() OVER(ORDER BY (sal.annual_salary/stats.goals::NUMERIC)) value_rank,
    players.player_name, stats.goals,
    ROUND((sal.annual_salary/stats.goals::NUMERIC),2) goal_value
FROM normalize_prem.fact_player_stats stats
INNER JOIN normalize_prem.dim_players players
    ON stats.player_id = players.player_id
INNER JOIN normalize_prem.fact_player_salaries sal
    ON stats.player_id = sal.player_id
WHERE stats.goals != 0
ORDER BY stats.goals DESC
LIMIT 20;

-- Top 20 goal scorers with annual salary also in top 30(fairly compensated players)

WITH goal_value_cte AS 
(
    SELECT RANK() OVER(ORDER BY sal.annual_salary DESC) salary_rank,
        players.player_name, stats.goals,
        ROUND((sal.annual_salary/stats.goals::NUMERIC),2) goal_value
    FROM normalize_prem.fact_player_stats stats
    INNER JOIN normalize_prem.dim_players players
        ON stats.player_id = players.player_id
    INNER JOIN normalize_prem.fact_player_salaries sal
        ON stats.player_id = sal.player_id
    WHERE stats.goals != 0
    ORDER BY stats.goals DESC
    LIMIT 20
)

SELECT *
FROM goal_value_cte
WHERE  salary_rank <=30
ORDER BY salary_rank;

-- Top 20 goal scorers with annual salaries not in top 30(underly compensated players)

WITH goal_value_cte AS 
(
    SELECT RANK() OVER(ORDER BY sal.annual_salary DESC) salary_rank,
        players.player_name, stats.goals,
        ROUND((sal.annual_salary/stats.goals::NUMERIC),2) goal_value
    FROM normalize_prem.fact_player_stats stats
    INNER JOIN normalize_prem.dim_players players
        ON stats.player_id = players.player_id
    INNER JOIN normalize_prem.fact_player_salaries sal
        ON stats.player_id = sal.player_id
    WHERE stats.goals != 0
    ORDER BY stats.goals DESC
    LIMIT 20
)

SELECT *
FROM goal_value_cte
WHERE  salary_rank > 30
ORDER BY salary_rank;

-- Players with annual salaries in the top 30 who are not top 20 goal scorers(overly compensated players)

WITH goal_value_cte AS 
(
    SELECT RANK() OVER(ORDER BY sal.annual_salary DESC) salary_rank,
        players.player_name, stats.goals,
        ROUND((sal.annual_salary/stats.goals::NUMERIC),2) goal_value
    FROM normalize_prem.fact_player_stats stats
    INNER JOIN normalize_prem.dim_players players
        ON stats.player_id = players.player_id
    INNER JOIN normalize_prem.fact_player_salaries sal
        ON stats.player_id = sal.player_id
    WHERE stats.goals != 0
    ORDER BY stats.goals DESC
)

SELECT *
FROM goal_value_cte
WHERE  salary_rank <=30
AND player_name not in 
    (
    SELECT players.player_name
    FROM normalize_prem.fact_player_stats stats
    INNER JOIN normalize_prem.dim_players players
        ON stats.player_id = players.player_id
    INNER JOIN normalize_prem.fact_player_salaries sal
        ON stats.player_id = sal.player_id
    WHERE stats.goals != 0
    ORDER BY stats.goals DESC
    LIMIT 20
    )
ORDER BY salary_rank;

-- Number of overcompensated players by team

WITH goal_value_cte AS 
(
    SELECT RANK() OVER(ORDER BY sal.annual_salary DESC) salary_rank,
        players.player_name, team.team_name, stats.goals,
        ROUND((sal.annual_salary/stats.goals::NUMERIC),2) goal_value
    FROM normalize_prem.fact_player_stats stats
    INNER JOIN normalize_prem.dim_players players
        ON stats.player_id = players.player_id
    INNER JOIN normalize_prem.fact_player_salaries sal
        ON stats.player_id = sal.player_id
    INNER JOIN normalize_prem.dim_teams team
        ON stats.team_id = team.team_id
    WHERE stats.goals != 0
    ORDER BY stats.goals DESC
),
overpaid_cte AS 
(
    SELECT *
    FROM goal_value_cte
    WHERE  salary_rank <=30
    AND player_name not in 
        (
        SELECT players.player_name
        FROM normalize_prem.fact_player_stats stats
        INNER JOIN normalize_prem.dim_players players
            ON stats.player_id = players.player_id
        INNER JOIN normalize_prem.fact_player_salaries sal
            ON stats.player_id = sal.player_id
        WHERE stats.goals != 0
        ORDER BY stats.goals DESC
        LIMIT 20
        )
    ORDER BY salary_rank
)

SELECT team_name, COUNT(*)
FROM overpaid_cte
GROUP BY team_name
ORDER BY COUNT(*) DESC;

-- Number of undercompensated players by team

WITH goal_value_cte AS 
(
    SELECT RANK() OVER(ORDER BY sal.annual_salary DESC) salary_rank,
        players.player_name, team.team_name, stats.goals,
        ROUND((sal.annual_salary/stats.goals::NUMERIC),2) goal_value
    FROM normalize_prem.fact_player_stats stats
    INNER JOIN normalize_prem.dim_players players
        ON stats.player_id = players.player_id
    INNER JOIN normalize_prem.fact_player_salaries sal
        ON stats.player_id = sal.player_id
    INNER JOIN normalize_prem.dim_teams team
        ON stats.team_id = team.team_id
    WHERE stats.goals != 0
    ORDER BY stats.goals DESC
    LIMIT 20
),
undercompensated_cte AS 
(
    SELECT *
    FROM goal_value_cte
    WHERE  salary_rank > 30
    ORDER BY salary_rank
)

SELECT team_name, COUNT(*)
FROM undercompensated_cte
GROUP BY team_name
ORDER BY COUNT(*) DESC;

