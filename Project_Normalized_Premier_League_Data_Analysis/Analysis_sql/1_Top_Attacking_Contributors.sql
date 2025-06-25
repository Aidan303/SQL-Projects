/* 
Question: What players contribute the most often on the score sheet?
-- Which players had the most number of total goals and assists?
-- Which players had the most numer of goal contributions relative to their minutes?
-- Which players contributed the most to their teams?
-- Why? The players that contribute the most on the score sheet are the "most valuable" players 
    they should be the best contributers in the league and these players can be analyzed later.
*/


-- Top 20 goal scorers in the league and their rank
SELECT RANK() OVER(ORDER BY stats.goals DESC),
    players.player_name, stats.goals
FROM normalize_prem.fact_player_stats stats
INNER JOIN normalize_prem.dim_players players
    ON stats.player_id = players.player_id
ORDER BY stats.goals DESC
LIMIT 20;

-- Top 20 goal assisters in the league and their rank
SELECT RANK () OVER(ORDER BY stats.assists DESC),
    players.player_name, stats.assists
FROM normalize_prem.fact_player_stats stats
INNER JOIN normalize_prem.dim_players players
    ON stats.player_id = players.player_id
ORDER BY stats.assists DESC
LIMIT 20;

-- Top 20 goal contributers in the league and their rank
SELECT RANK() OVER(ORDER BY (stats.goals + stats.assists) DESC),
    players.player_name, (stats.assists + stats.goals) AS goal_contributions
FROM normalize_prem.fact_player_stats stats
INNER JOIN normalize_prem.dim_players players
    ON stats.player_id = players.player_id
ORDER BY goal_contributions DESC
LIMIT 20;

-- Top 20 goal contributers in the league per 90 and their rank

WITH contributions_per_90 AS 
(
    SELECT stats.player_id, 
        ROUND(((SUM(stats.goals) + SUM(stats.assists)) / (SUM(stats.minutes)::NUMERIC / 90)), 2) AS per_90
    FROM normalize_prem.fact_player_stats stats
    GROUP BY stats.player_id
)

SELECT RANK() OVER (ORDER BY c.per_90 DESC) AS rank,
    p.player_name,
    c.per_90
FROM contributions_per_90 c
JOIN normalize_prem.dim_players p
    ON c.player_id = p.player_id
ORDER BY c.per_90 DESC
LIMIT 20;

