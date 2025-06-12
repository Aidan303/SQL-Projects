SELECT *
FROM normalize_prem.dim_players player
LEFT JOIN normalize_prem.fact_player_possession_stats possession
ON player.player_id = possession.player_id
WHERE nation = 'United States';

SELECT teams.team_name, total_annual_salary
FROM normalize_prem.dim_teams teams
INNER JOIN normalize_prem.fact_team_salaries salaries
ON teams.team_id = salaries.team_id;