-- Create table for individual player possession stats

CREATE TABLE IF NOT EXISTS prem.player_possession_stats
(
    player VARCHAR(50),
    nation VARCHAR(3),
    position VARCHAR(10),
    team VARCHAR(50),
    age FLOAT,
    full_matches_played FLOAT,
    touches INT,
    defensive_touches INT,
    middle_touches INT,
    attacking_touches INT,
    take_on_attempts INT,
    successful_take_on INT,
    take_on_tackled INT,
    carries INT,
    distance_carried INT,
    passes_received INT
);

-- Create table for individual player salary stats

CREATE TABLE IF NOT EXISTS prem.player_salaries
(
    name VARCHAR(50),
    nation VARCHAR(3),
    position VARCHAR(10),
    team VARCHAR(50),
    age FLOAT,
    weekly_salary INT,
    annual_salary INT
);

-- Create table for individual player all around stats

CREATE TABLE IF NOT EXISTS prem.player_stats
(
    name VARCHAR(50),
    nation VARCHAR(50),
    position VARCHAR(10),
    team VARCHAR(50),
    age FLOAT,
    year_born FLOAT,
    games_played INT,
    starts INT,
    minutes INT,
    goals INT,
    assists INT,
    penalty_kicks_scored INT,
    penalty_kicks_taken INT,
    yellows INT,
    reds INT,
    xg FLOAT,
    progressive_carries INT,
    progressive_passes INT,
    received_progressive_passes INT
);

-- Create table for league standings

CREATE TABLE IF NOT EXISTS prem.standings
(
    rank INT,
    team VARCHAR(50) PRIMARY KEY,
    games_won INT,
    games_lost INT,
    games_drawn INT,
    goals_for INT,
    goals_against INT,
    points INT,
    last_five VARCHAR(50),
    top_scorer VARCHAR(50),
    keeper VARCHAR(50)
);

-- Create table for team possession stats

CREATE TABLE IF NOT EXISTS prem.team_possession_stats
(
    team VARCHAR(50) PRIMARY KEY,
    possession FLOAT,
    touches INT,
    defensive_touches INT,
    middle_touches INT,
    attacking_touches INT,
    take_on_attempts INT,
    successful_take_on INT,
    carries INT,
    distance_carried INT
);

-- Create table for total team wage bill stats

CREATE TABLE IF NOT EXISTS prem.team_salary
(
    team VARCHAR(50) PRIMARY KEY,
    num_players INT,
    weekly_wages INT,
    annual_wages INT
);

-- Create table for team all around stats

CREATE TABLE IF NOT EXISTS prem.team_stats
(
    team VARCHAR(50) PRIMARY KEY,
    num_players INT,
    avg_age FLOAT,
    possession FLOAT,
    goals_for INT,
    assists INT,
    penalty_kicks_scored INT,
    penalty_kicks_taken INT,
    yellows INT,
    reds INT,
    xg FLOAT,
    xa FlOAT,
    progressive_carries INT,
    progressive_passes INT
);