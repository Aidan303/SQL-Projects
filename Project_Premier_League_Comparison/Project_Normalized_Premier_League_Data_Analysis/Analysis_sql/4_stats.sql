/*
Question: Who are the top dribblers in the leauge, who are the top passers? Does this
    match up with goals or assists? Who are the players under/over preforming their 
    expected goal numbers?

*/

-- Top dribblers in the league
SELECT player_name, progressive_carries
FROM normalize_prem.fact_player_stats stats
INNER JOIN normalize_prem.dim_players dim
    ON stats.player_id = dim.player_id
ORDER BY progressive_carries DESC;

-- Top progressive passers in the league
SELECT player_name, progressive_passes
FROM normalize_prem.fact_player_stats stats
INNER JOIN normalize_prem.dim_players dim
    ON stats.player_id = dim.player_id
ORDER BY progressive_passes DESC;

-- Top receivers of progressive passes
SELECT player_name, received_progressive_passes
FROM normalize_prem.fact_player_stats stats
INNER JOIN normalize_prem.dim_players dim
    ON stats.player_id = dim.player_id
ORDER BY received_progressive_passes DESC;

-- Top combined carriers and progressive pass receivers
SELECT player_name, SUM(received_progressive_passes + progressive_carries) AS progressive_opportunities
FROM normalize_prem.fact_player_stats stats
INNER JOIN normalize_prem.dim_players dim
    ON stats.player_id = dim.player_id
GROUP BY player_name
ORDER BY progressive_opportunities DESC;

-- Players with the highest expected goals value
SELECT player_name, expected_goals
FROM normalize_prem.fact_player_stats stats
INNER JOIN normalize_prem.dim_players dim
    ON stats.player_id = dim.player_id
ORDER BY expected_goals DESC;

-- Top players total goals
SELECT player_name, goals
FROM normalize_prem.fact_player_stats stats
INNER JOIN normalize_prem.dim_players dim
    ON stats.player_id = dim.player_id
ORDER BY goals DESC;

-- Over/Underpreforming of expected goals by player
SELECT player_name, SUM(goals::NUMERIC - expected_goals) AS goal_difference
FROM normalize_prem.fact_player_stats stats
INNER JOIN normalize_prem.dim_players dim
    ON stats.player_id = dim.player_id
GROUP BY player_name
ORDER BY goal_difference DESC;

-- Number of goals per opportunity generated from a progressive carry or recieved pass
WITH total_opportunities AS 
(
    SELECT stats.player_id, player_name, (received_progressive_passes + progressive_carries) AS progressive_opportunities
    FROM normalize_prem.fact_player_stats stats
    INNER JOIN normalize_prem.dim_players dim
        ON stats.player_id = dim.player_id
    WHERE stats.goals != 0
    ORDER BY progressive_opportunities DESC
)

SELECT player_name, ROUND((stats.goals/progressive_opportunities::NUMERIC),4) AS goals_per_opp
FROM total_opportunities cte
INNER JOIN normalize_prem.fact_player_stats stats
    ON cte.player_id = stats.player_id
ORDER BY goals_per_opp DESC;

-- Players who are overpreforming their XG and their number of goals per opportunity
WITH overpreformers AS
(
    SELECT player_name, SUM(goals::NUMERIC - expected_goals) AS goal_difference
    FROM normalize_prem.fact_player_stats stats
    INNER JOIN normalize_prem.dim_players dim
        ON stats.player_id = dim.player_id
    GROUP BY player_name
    HAVING SUM(goals::NUMERIC - expected_goals) > 0
    ORDER BY goal_difference DESC
),
total_opportunities AS
(
    SELECT stats.player_id, player_name, stats.expected_goals, (received_progressive_passes + progressive_carries) AS progressive_opportunities
    FROM normalize_prem.fact_player_stats stats
    INNER JOIN normalize_prem.dim_players dim
        ON stats.player_id = dim.player_id
    WHERE stats.goals != 0
    ORDER BY progressive_opportunities DESC
),
goals_per_opp AS
(
    SELECT player_name, ROUND((stats.goals/progressive_opportunities::NUMERIC),2) AS goals_per_opp
    FROM total_opportunities cte
    INNER JOIN normalize_prem.fact_player_stats stats
        ON cte.player_id = stats.player_id
    ORDER BY goals_per_opp DESC
)

SELECT tot.player_name, over.goal_difference, gpo.goals_per_opp
FROM total_opportunities tot
INNER JOIN goals_per_opp gpo
    ON tot.player_name = gpo.player_name
INNER JOIN overpreformers over
    ON tot.player_name = over.player_name
WHERE goals_per_opp > 0.1
ORDER BY gpo.goals_per_opp DESC;