SELECT DISTINCT(salary.name), salary.team, salary.annual_salary, stats.team, stats.goals, stats.assists
FROM prem.player_salaries salary
LEFT JOIN prem.player_stats stats
ON salary.name = stats.name
AND salary.team = stats.team
WHERE salary.position LIKE '%MF%'
AND stats.goals IS NOT NULL
ORDER BY salary.annual_salary DESC, stats.goals DESC;

SELECT *
FROM prem.player_salaries salary
LEFT JOIN prem.player_stats stats
on salary.name = stats.name
WHERE salary.name = 'marcus rashford';



SELECT team.team, team.progressive_carries, 
    player.name, player.progressive_carries,
    ROUND(((player.progressive_carries::NUMERIC)/team.progressive_carries) * 100, 2) AS percent_of_carries
FROM prem.team_stats team
LEFT JOIN prem.player_stats player
ON team.team = player.team
WHERE team.team = 'Arsenal'
ORDER BY player.progressive_carries DESC;




