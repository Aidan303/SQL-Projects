/*
Question: Which are the most cost effective teams?
-- What is the total goals above expected for each team?
-- What is the cost for these players in annual wage?
-- What is the cost per goal over expected for each team?
-- Why? We can find what teams are paying their players and if they are 
    making cost effective signings for their roster.
*/


-- Team over/under premforming of their expected goals as a sum of their players

SELECT team_name, SUM(goals::NUMERIC - expected_goals) AS goal_difference
FROM normalize_prem.fact_player_stats stats
INNER JOIN normalize_prem.dim_teams dim
    ON stats.team_id = dim.team_id
GROUP BY team_name
ORDER BY goal_difference DESC;

-- Teams total annual wage bill for players who contribute to the preformance stat above

SELECT dim.team_name, SUM(sal.annual_salary) as total_annual_salary
FROM normalize_prem.fact_player_stats stats
INNER JOIN normalize_prem.fact_player_salaries sal
    ON stats.player_id = sal.player_id
INNER JOIN normalize_prem.dim_teams dim
    ON stats.team_id = dim.team_id
GROUP BY dim.team_name;

-- Cost per goal over expected for each team

WITH team_salaries AS
(
    SELECT dim.team_name, SUM(sal.annual_salary) as total_annual_salary
    FROM normalize_prem.fact_player_stats stats
    INNER JOIN normalize_prem.fact_player_salaries sal
        ON stats.player_id = sal.player_id
    INNER JOIN normalize_prem.dim_teams dim
        ON stats.team_id = dim.team_id
    GROUP BY dim.team_name
),
team_goal_difference AS
(
    SELECT team_name, SUM(goals::NUMERIC - expected_goals) AS goal_difference
    FROM normalize_prem.fact_player_stats stats
    INNER JOIN normalize_prem.dim_teams dim
        ON stats.team_id = dim.team_id
    GROUP BY team_name
    ORDER BY goal_difference DESC
)

SELECT sal.team_name, ROUND((total_annual_salary/goal_difference), 2) AS salary_per_gd
FROM team_salaries sal
INNER JOIN team_goal_difference gd
    ON sal.team_name = gd.team_name
ORDER BY (total_annual_salary/goal_difference);

-- Cost per goal over expected for each team with positive preformance

WITH team_salaries AS
(
    SELECT dim.team_name, SUM(sal.annual_salary) as total_annual_salary
    FROM normalize_prem.fact_player_stats stats
    INNER JOIN normalize_prem.fact_player_salaries sal
        ON stats.player_id = sal.player_id
    INNER JOIN normalize_prem.dim_teams dim
        ON stats.team_id = dim.team_id
    GROUP BY dim.team_name
),
team_goal_difference AS
(
    SELECT team_name, SUM(goals::NUMERIC - expected_goals) AS goal_difference
    FROM normalize_prem.fact_player_stats stats
    INNER JOIN normalize_prem.dim_teams dim
        ON stats.team_id = dim.team_id
    GROUP BY team_name
    ORDER BY goal_difference DESC
)

SELECT sal.team_name, ROUND((total_annual_salary/goal_difference), 2) AS salary_per_gd
FROM team_salaries sal
INNER JOIN team_goal_difference gd
    ON sal.team_name = gd.team_name
WHERE (total_annual_salary/goal_difference) > 0
ORDER BY (total_annual_salary/goal_difference);