/*
\copy prem.player_possession_stats FROM 'C:\Users\aidan\SQL Projects\csv_files\Prem CSV Files\player_possession_stats.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy prem.player_salaries FROM 'C:\Users\aidan\SQL Projects\csv_files\Prem CSV Files\player_salaries.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy prem.player_stats FROM 'C:\Users\aidan\SQL Projects\csv_files\Prem CSV Files\player_stats.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy prem.standings FROM 'C:\Users\aidan\SQL Projects\csv_files\Prem CSV Files\standings.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy prem.team_possession_stats FROM 'C:\Users\aidan\SQL Projects\csv_files\Prem CSV Files\team_possession_stats.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy prem.team_salary FROM 'C:\Users\aidan\SQL Projects\csv_files\Prem CSV Files\team_salary.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy prem.team_stats FROM 'C:\Users\aidan\SQL Projects\csv_files\Prem CSV Files\team_stats.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
*/




COPY prem.player_possession_stats
FROM 'C:\Users\aidan\SQL Projects\csv_files\Prem CSV Files\player_possession_stats.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY prem.player_salaries
FROM 'C:\Users\aidan\SQL Projects\csv_files\Prem CSV Files\player_salaries.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY prem.player_stats
FROM 'C:\Users\aidan\SQL Projects\csv_files\Prem CSV Files\player_stats.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY prem.standings
FROM 'C:\Users\aidan\SQL Projects\csv_files\Prem CSV Files\standings.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY prem.team_possession_stats
FROM 'C:\Users\aidan\SQL Projects\csv_files\Prem CSV Files\team_possession_stats.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY prem.team_salary
FROM 'C:\Users\aidan\SQL Projects\csv_files\Prem CSV Files\team_salary.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY prem.team_stats
FROM 'C:\Users\aidan\SQL Projects\csv_files\Prem CSV Files\team_stats.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

