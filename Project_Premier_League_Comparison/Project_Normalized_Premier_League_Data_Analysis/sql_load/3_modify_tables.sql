/*
\copy normalize_prem.dim_players FROM 'C:\Users\aidan\SQL Projects\csv_files\Prem CSV Files\Normalized Sheets\Dim_Players.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy normalize_prem.dim_teams FROM 'C:\Users\aidan\SQL Projects\csv_files\Prem CSV Files\Normalized Sheets\Dim_Teams.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy normalize_prem.fact_player_possession_stats FROM 'C:\Users\aidan\SQL Projects\csv_files\Prem CSV Files\Normalized Sheets\Fact_Player_Possession_Stats.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy normalize_prem.fact_player_salaries FROM 'C:\Users\aidan\SQL Projects\csv_files\Prem CSV Files\Normalized Sheets\Fact_Player_Salaries.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy normalize_prem.fact_player_stats FROM 'C:\Users\aidan\SQL Projects\csv_files\Prem CSV Files\Normalized Sheets\Fact_Player_Stats.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy normalize_prem.fact_standings FROM 'C:\Users\aidan\SQL Projects\csv_files\Prem CSV Files\Normalized Sheets\Fact_Standings.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy normalize_prem.fact_team_overall_stats FROM 'C:\Users\aidan\SQL Projects\csv_files\Prem CSV Files\Normalized Sheets\Fact_Team_Overall_Stats.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy normalize_prem.fact_team_possession_stats FROM 'C:\Users\aidan\SQL Projects\csv_files\Prem CSV Files\Normalized Sheets\Fact_Team_Possession_Stats.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy normalize_prem.fact_team_salaries FROM 'C:\Users\aidan\SQL Projects\csv_files\Prem CSV Files\Normalized Sheets\Fact_Team_Salaries.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

*/




COPY normalize_prem.dim_players
FROM 'C:\Users\aidan\SQL Projects\csv_files\Prem CSV Files\Normalized Sheets\Dim_Players.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY normalize_prem.dim_teams
FROM 'C:\Users\aidan\SQL Projects\csv_files\Prem CSV Files\Normalized Sheets\Dim_Teams.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY normalize_prem.fact_player_possession_stats
FROM 'C:\Users\aidan\SQL Projects\csv_files\Prem CSV Files\Normalized Sheets\Fact_Player_Possession_Stats.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY normalize_prem.fact_player_salaries
FROM 'C:\Users\aidan\SQL Projects\csv_files\Prem CSV Files\Normalized Sheets\Fact_Player_Salaries.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY normalize_prem.fact_player_stats
FROM 'C:\Users\aidan\SQL Projects\csv_files\Prem CSV Files\Normalized Sheets\Fact_Player_Stats.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY normalize_prem.fact_standings
FROM 'C:\Users\aidan\SQL Projects\csv_files\Prem CSV Files\Normalized Sheets\Fact_Standings.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY normalize_prem.fact_team_overall_stats
FROM 'C:\Users\aidan\SQL Projects\csv_files\Prem CSV Files\Normalized Sheets\Fact_Team_Overall_Stats.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY normalize_prem.fact_team_possession_stats
FROM 'C:\Users\aidan\SQL Projects\csv_files\Prem CSV Files\Normalized Sheets\Fact_Team_Possession_Stats.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY normalize_prem.fact_team_salaries
FROM 'C:\Users\aidan\SQL Projects\csv_files\Prem CSV Files\Normalized Sheets\Fact_Team_Salaries.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');