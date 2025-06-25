/*
Questions: Who are the top paid players in the leauge?
-- Which players have the highest weekly and annual salaries?
-- What positions do they play?
-- What teams do they play for?
-- How do teams allocate their money?
-- Why? Are the top paid players the most impactful in other metrics? Which teams spend the most?
    How do teams spend their money? Which positions are the highest paid? Are there outliers, Why?
*/


-- Top 20 highest paid players in the league(annual).

SELECT RANK() OVER(ORDER BY sal.annual_salary DESC),
    dim.player_name, sal.annual_salary
FROM normalize_prem.fact_player_salaries sal
INNER JOIN normalize_prem.dim_players dim
    ON sal.player_id = dim.player_id
ORDER BY sal.annual_salary DESC
LIMIT 20;

-- Top 20 highest paid players in the league(weekly).

SELECT RANK() OVER(ORDER BY sal.weekly_salary DESC),
    dim.player_name, sal.weekly_salary
FROM normalize_prem.fact_player_salaries sal
INNER JOIN normalize_prem.dim_players dim
    ON sal.player_id = dim.player_id
ORDER BY sal.weekly_salary DESC
LIMIT 20;

-- Average annual pay per position as well as position type

WITH base_position_cte AS
(
    SELECT dim.position, ROUND(AVG(sal.annual_salary),2) avg_position_salary,
    CASE
        WHEN dim.position LIKE '%,%' THEN 'Utility'
        ELSE 'Singular'
    END AS type_position
    FROM normalize_prem.fact_player_salaries sal
    INNER JOIN normalize_prem.dim_players dim
        ON sal.player_id = dim.player_id
    WHERE position IS NOT NULL
    GROUP BY position
),
position_combination_cte AS
(
    SELECT *,
        CASE
            WHEN position LIKE 'DF,MF' THEN 'Def/Mid'
            WHEN position LIKE 'MF,DF' THEN 'Def/Mid'
            WHEN position LIKE 'MF,FW' THEN 'Mid/Fwd'
            WHEN position LIKE 'FW,MF' THEN 'Mid/Fwd'
            WHEN position LIKE 'FW,DF' THEN 'Def/Fwd'
            WHEN position LIKE 'DF,FW' THEN 'Def/Fwd'
        END AS position_final
    FROM base_position_cte
    WHERE type_position = 'Utility'
),
utility_summary AS (
    SELECT position_final AS position, 
           ROUND(AVG(avg_position_salary), 2) AS avg_position_salary, 
           'Utility' AS type_position
    FROM position_combination_cte
    GROUP BY position_final
),
singular_summary AS (
    SELECT position AS position, 
           avg_position_salary, 
           type_position
    FROM base_position_cte
    WHERE type_position = 'Singular'
)

SELECT * FROM utility_summary
UNION
SELECT * FROM singular_summary
ORDER BY avg_position_salary DESC;

-- Teams with the Highest annual wage bill

SELECT RANK() OVER(ORDER BY sal.total_annual_salary DESC),
    dim.team_name, sal.total_players_in_team, sal.total_annual_salary
FROM normalize_prem.fact_team_salaries sal
INNER JOIN normalize_prem.dim_teams dim
ON sal.team_id = dim.team_id
ORDER BY sal.total_annual_salary DESC;

-- Teams with the highest wage per player

SELECT RANK() OVER(ORDER BY (sal.total_annual_salary/sal.total_players_in_team) DESC),
    dim.team_name, sal.total_players_in_team, 
    (sal.total_annual_salary/sal.total_players_in_team) AS wage_per_player
FROM normalize_prem.fact_team_salaries sal
INNER JOIN normalize_prem.dim_teams dim
ON sal.team_id = dim.team_id
ORDER BY wage_per_player DESC;

-- What percentage of a teams wage bill goes to their 11 highest paid players (i.e. Starting 11)

WITH team_salary_cte AS 
(
    SELECT dim.player_name, stat.team_id, sal.*, ROW_NUMBER() OVER(PARTITION BY stat.team_id ORDER BY sal.annual_salary DESC) AS row_num
    FROM normalize_prem.fact_player_salaries sal
    INNER JOIN normalize_prem.dim_players dim
    ON sal.player_id = dim.player_id
    LEFT JOIN normalize_prem.fact_player_stats stat
    ON sal.player_id = stat.player_id
    ORDER BY stat.team_id, sal.annual_salary DESC
),
top_eleven_cte AS (
    SELECT team.team_id, SUM(sal.annual_salary) AS eleven_salary
    FROM team_salary_cte as sal
    INNER JOIN normalize_prem.dim_teams team
    ON sal.team_id = team.team_id
    WHERE row_num <= 11
    AND sal.team_id IS NOT NULL
    GROUP BY team.team_id
    ORDER BY eleven_salary DESC
)

SELECT dim.team_name, ROUND((top.eleven_salary/sal.total_annual_salary::NUMERIC),2) AS percent
FROM top_eleven_cte top
INNER JOIN normalize_prem.fact_team_salaries sal
ON top.team_id = sal.team_id
INNER JOIN normalize_prem.dim_teams dim
ON top.team_id = dim.team_id
ORDER BY percent DESC;