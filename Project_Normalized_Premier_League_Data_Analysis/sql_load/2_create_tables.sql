CREATE TABLE IF NOT EXISTS normalize_prem.dim_players
(
    player_id INT PRIMARY KEY,
    player_name VARCHAR(50),
    nation VARCHAR(50),
    position VARCHAR(20),
    age NUMERIC,
    born_year INT
);

CREATE TABLE IF NOT EXISTS normalize_prem.dim_teams
(
    team_id INT PRIMARY KEY,
    team_name VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS normalize_prem.fact_player_possession_stats
(
    player_possession_id INT PRIMARY KEY,
    player_id INT,
    full_games NUMERIC,
    touches INT,
    defensive_touches INT,
    middle_touches INT,
    attacking_touches INT,
    attempted_take_ons INT,
    successful_take_ons INT,
    take_ons_tackled INT,
    carries INT,
    total_distance_carried INT,
    passes_received INT
);

CREATE TABLE IF NOT EXISTS normalize_prem.fact_player_salaries
(
    player_salary_id INT PRIMARY KEY,
    player_id INT,
    weekly_salary INT,
    annual_salary INT
);

CREATE TABLE IF NOT EXISTS normalize_prem.fact_player_stats
(
    player_stats_id INT PRIMARY KEY,
    player_id INT,
    team_id INT,
    matches_played INT,
    matches_started INT,
    minutes INT,
    goals INT,
    assists INT,
    penalty_kicks_scored INT,
    penalty_kicks_attempted INT,
    yellows INT,
    reds INT,
    expected_goals NUMERIC,
    progressive_carries INT,
    progressive_passes INT,
    received_progressive_passes INT
);

CREATE TABLE IF NOT EXISTS normalize_prem.fact_standings
(
    standings_id INT PRIMARY KEY,
    team_id INT,
    rank INT,
    wins INT,
    losses INT,
    draws INT,
    goals_for INT,
    goals_against INT,
    points INT,
    last_five VARCHAR(9)
);

CREATE TABLE IF NOT EXISTS normalize_prem.fact_team_overall_stats
(
    team_overall_id INT PRIMARY KEY,
    team_id INT,
    player_count INT,
    average_age NUMERIC,
    possession_percentage NUMERIC,
    goals_scored INT,
    assists INT,
    penalty_kicks_scored INT,
    penalty_kicks_attempted INT,
    yellows INT,
    reds INT,
    expected_goals NUMERIC,
    expected_assists NUMERIC,
    progressive_carries INT,
    progressive_passes INT
);

CREATE TABLE IF NOT EXISTS normalize_prem.fact_team_possession_stats
(
    team_possession_id INT PRIMARY KEY,
    team_id INT,
    touches INT,
    defensive_touches INT,
    middle_touches INT,
    attacking_touches INT,
    attempted_take_ons INT,
    successful_take_ons INT,
    carries INT,
    total_distance_carried INT
);

CREATE TABLE IF NOT EXISTS normalize_prem.fact_team_salaries
(
   team_salary_id INT PRIMARY KEY,
   team_id INT,
   total_players_in_team INT,
   total_weekly_salary INT,
   total_annual_salary INT 
);


-- fact_player_possession_stats.player_id → dim_players.player_id
ALTER TABLE normalize_prem.fact_player_possession_stats
ADD CONSTRAINT fk_fact_player_possession_stats_player
FOREIGN KEY (player_id)
REFERENCES normalize_prem.dim_players(player_id);

-- fact_player_salaries.player_id → dim_players.player_id
ALTER TABLE normalize_prem.fact_player_salaries
ADD CONSTRAINT fk_fact_player_salaries_player
FOREIGN KEY (player_id)
REFERENCES normalize_prem.dim_players(player_id);

-- fact_player_stats.player_id → dim_players.player_id
ALTER TABLE normalize_prem.fact_player_stats
ADD CONSTRAINT fk_fact_player_stats_player
FOREIGN KEY (player_id)
REFERENCES normalize_prem.dim_players(player_id);

-- fact_player_stats.team_id → dim_teams.team_id
ALTER TABLE normalize_prem.fact_player_stats
ADD CONSTRAINT fk_fact_player_stats_team
FOREIGN KEY (team_id)
REFERENCES normalize_prem.dim_teams(team_id);

-- fact_standings.team_id → dim_teams.team_id
ALTER TABLE normalize_prem.fact_standings
ADD CONSTRAINT fk_fact_standings_team
FOREIGN KEY (team_id)
REFERENCES normalize_prem.dim_teams(team_id);

-- fact_team_overall_stats.team_id → dim_teams.team_id
ALTER TABLE normalize_prem.fact_team_overall_stats
ADD CONSTRAINT fk_fact_team_overall_stats_team
FOREIGN KEY (team_id)
REFERENCES normalize_prem.dim_teams(team_id);

-- fact_team_possession_stats.team_id → dim_teams.team_id
ALTER TABLE normalize_prem.fact_team_possession_stats
ADD CONSTRAINT fk_fact_team_possession_stats_team
FOREIGN KEY (team_id)
REFERENCES normalize_prem.dim_teams(team_id);

-- fact_team_salaries.team_id → dim_teams.team_id
ALTER TABLE normalize_prem.fact_team_salaries
ADD CONSTRAINT fk_fact_team_salaries_team
FOREIGN KEY (team_id)
REFERENCES normalize_prem.dim_teams(team_id);
