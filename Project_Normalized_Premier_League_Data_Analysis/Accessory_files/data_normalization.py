import pandas as pd

# Load all original CSV files
df_player_stats = pd.read_csv('player_stats_cleaned.csv')
df_player_possession_stats = pd.read_csv('player_possession_stats_cleaned.csv')
df_player_salaries = pd.read_csv('player_salaries_cleaned.csv')
df_standings = pd.read_csv('standings.csv')
df_team_possession_stats = pd.read_csv('team_possession_stats.csv')
df_team_salary = pd.read_csv('team_salary.csv')
df_team_stats = pd.read_csv('team_stats.csv')

# --- Phase 1: Create Dimension Tables ---

# 1. Create Dim_Teams
all_teams = pd.concat([
    df_player_stats['team'],
    df_player_possession_stats['team'],
    df_player_salaries['Team'],
    df_standings['team'],
    df_team_possession_stats['team'],
    df_team_salary['team'],
    df_team_stats['team']
]).unique()

df_dim_teams = pd.DataFrame(all_teams, columns=['team_name'])
df_dim_teams['team_id'] = df_dim_teams.index + 1 # Assign auto-incrementing ID
df_dim_teams = df_dim_teams[['team_id', 'team_name']] # Reorder columns
df_dim_teams.to_csv('Dim_Teams.csv', index=False)

print("Generated Dim_Teams.csv")

# 2. Create Dim_Players
# Combine player details from different sources, prioritizing 'player_stats_cleaned' for initial data
player_data_from_stats = df_player_stats[['cleaned_player_name', 'nation', 'position', 'age', 'born']].copy()
player_data_from_salaries = df_player_salaries[['cleaned_player_name', 'Nation', 'Position', 'Age']].copy()
player_data_from_possession = df_player_possession_stats[['cleaned_player_name', 'nation', 'position', 'age']].copy()


# Standardize column names for merging
player_data_from_salaries.rename(columns={'Nation': 'nation', 'Position': 'position', 'Age': 'age'}, inplace=True)

# Combine and remove duplicates based on player name
all_player_details = pd.concat([player_data_from_stats, player_data_from_salaries, player_data_from_possession]).drop_duplicates(subset=['cleaned_player_name']).reset_index(drop=True)

# Corrected handling of 'born' column to 'born_year'
# Convert to numeric, coercing errors to NaN, then to nullable integer type
all_player_details['born_year'] = pd.to_numeric(all_player_details['born'], errors='coerce').astype('Int64')
all_player_details.drop(columns=['born'], inplace=True)

df_dim_players = all_player_details.rename(columns={'cleaned_player_name': 'player_name'})
df_dim_players['player_id'] = df_dim_players.index + 1 # Assign auto-incrementing ID
df_dim_players = df_dim_players[['player_id', 'player_name', 'nation', 'position', 'age', 'born_year']] # Reorder columns
df_dim_players.to_csv('Dim_Players.csv', index=False)

print("Generated Dim_Players.csv")

# Create dictionaries for mapping
team_name_to_id = df_dim_teams.set_index('team_name')['team_id'].to_dict()
player_name_to_id = df_dim_players.set_index('player_name')['player_id'].to_dict()

# --- Phase 2: Create Fact Tables ---

# 1. Fact_Player_Stats
df_fact_player_stats = df_player_stats.copy()
df_fact_player_stats['player_id'] = df_fact_player_stats['cleaned_player_name'].map(player_name_to_id)
df_fact_player_stats['team_id'] = df_fact_player_stats['team'].map(team_name_to_id)

df_fact_player_stats = df_fact_player_stats.rename(columns={
    'played': 'matches_played',
    'yellow': 'yellow_cards',
    'red': 'red_cards'
})
df_fact_player_stats = df_fact_player_stats[[
    'player_id', 'team_id', 'matches_played', 'starts', 'minutes', 'goals', 'assists',
    'penalty_kicks', 'penalty_kick_attempts', 'yellow_cards', 'red_cards',
    'expected_goals', 'progressive_carries', 'progressive_passes', 'received_progressive_passes'
]]
df_fact_player_stats['player_stats_id'] = df_fact_player_stats.index + 1
df_fact_player_stats = df_fact_player_stats[['player_stats_id'] + df_fact_player_stats.columns[:-1].tolist()] # Reorder PK to front
df_fact_player_stats.to_csv('Fact_Player_Stats.csv', index=False)

print("Generated Fact_Player_Stats.csv")


# 2. Fact_Player_Possession_Stats
df_fact_player_possession_stats = df_player_possession_stats.copy()
df_fact_player_possession_stats['player_id'] = df_fact_player_possession_stats['cleaned_player_name'].map(player_name_to_id)

df_fact_player_possession_stats = df_fact_player_possession_stats.rename(columns={
    '90s': 'nineties_played',
    'deffensive_touches': 'defensive_touches',
    'middle_touches': 'middle_third_touches',
    'attacking_touches': 'attacking_third_touches',
    'takeons_tackled': 'take_ons_tackled',
    'received': 'passes_received'
})
df_fact_player_possession_stats = df_fact_player_possession_stats[[
    'player_id', 'nineties_played', 'touches', 'defensive_touches',
    'middle_third_touches', 'attacking_third_touches', 'attempted_take_ons',
    'successful_take_ons', 'take_ons_tackled', 'carries', 'total_distance_carried',
    'passes_received'
]]
df_fact_player_possession_stats['player_possession_id'] = df_fact_player_possession_stats.index + 1
df_fact_player_possession_stats = df_fact_player_possession_stats[['player_possession_id'] + df_fact_player_possession_stats.columns[:-1].tolist()]
df_fact_player_possession_stats.to_csv('Fact_Player_Possession_Stats.csv', index=False)

print("Generated Fact_Player_Possession_Stats.csv")

# 3. Fact_Player_Salaries
df_fact_player_salaries = df_player_salaries.copy()
df_fact_player_salaries['player_id'] = df_fact_player_salaries['cleaned_player_name'].map(player_name_to_id)

df_fact_player_salaries = df_fact_player_salaries.rename(columns={
    'Weekly': 'weekly_salary',
    'Annual': 'annual_salary'
})
df_fact_player_salaries = df_fact_player_salaries[[
    'player_id', 'weekly_salary', 'annual_salary'
]]
df_fact_player_salaries['player_salary_id'] = df_fact_player_salaries.index + 1
df_fact_player_salaries = df_fact_player_salaries[['player_salary_id'] + df_fact_player_salaries.columns[:-1].tolist()]
df_fact_player_salaries.to_csv('Fact_Player_Salaries.csv', index=False)

print("Generated Fact_Player_Salaries.csv")

# 4. Fact_Team_Overall_Stats
df_fact_team_overall_stats = df_team_stats.copy()
df_fact_team_overall_stats['team_id'] = df_fact_team_overall_stats['team'].map(team_name_to_id)

df_fact_team_overall_stats = df_fact_team_overall_stats.rename(columns={
    'players': 'player_count',
    'age': 'average_age',
    'possession': 'possession_percentage',
    'goals': 'goals_scored',
    'yellows': 'yellow_cards',
    'reds': 'red_cards'
})
df_fact_team_overall_stats = df_fact_team_overall_stats[[
    'team_id', 'player_count', 'average_age', 'possession_percentage',
    'goals_scored', 'assists', 'penalty_kicks', 'penalty_kick_attempts',
    'yellow_cards', 'red_cards', 'expected_goals', 'expected_assists',
    'progressive_carries', 'progressive_passes'
]]
df_fact_team_overall_stats['team_overall_stats_id'] = df_fact_team_overall_stats.index + 1
df_fact_team_overall_stats = df_fact_team_overall_stats[['team_overall_stats_id'] + df_fact_team_overall_stats.columns[:-1].tolist()]
df_fact_team_overall_stats.to_csv('Fact_Team_Overall_Stats.csv', index=False)

print("Generated Fact_Team_Overall_Stats.csv")


# 5. Fact_Team_Possession_Stats
df_fact_team_possession_stats = df_team_possession_stats.copy()
df_fact_team_possession_stats['team_id'] = df_fact_team_possession_stats['team'].map(team_name_to_id)

df_fact_team_possession_stats = df_fact_team_possession_stats.rename(columns={
    'deffensive_touches': 'defensive_touches',
    'middle_touches': 'middle_third_touches',
    'attacking_touches': 'attacking_third_touches'
})
df_fact_team_possession_stats = df_fact_team_possession_stats[[
    'team_id', 'touches', 'defensive_touches', 'middle_third_touches',
    'attacking_third_touches', 'attempted_take_ons', 'successful_take_ons',
    'carries', 'total_distance_carried'
]]
df_fact_team_possession_stats['team_possession_id'] = df_fact_team_possession_stats.index + 1
df_fact_team_possession_stats = df_fact_team_possession_stats[['team_possession_id'] + df_fact_team_possession_stats.columns[:-1].tolist()]
df_fact_team_possession_stats.to_csv('Fact_Team_Possession_Stats.csv', index=False)

print("Generated Fact_Team_Possession_Stats.csv")

# 6. Fact_Team_Salaries
df_fact_team_salaries = df_team_salary.copy()
df_fact_team_salaries['team_id'] = df_fact_team_salaries['team'].map(team_name_to_id)

df_fact_team_salaries = df_fact_team_salaries.rename(columns={
    'players': 'total_players_in_team_salary',
    'weekly': 'total_weekly_salary',
    'annual': 'total_annual_salary'
})
df_fact_team_salaries = df_fact_team_salaries[[
    'team_id', 'total_players_in_team_salary', 'total_weekly_salary', 'total_annual_salary'
]]
df_fact_team_salaries['team_salary_id'] = df_fact_team_salaries.index + 1
df_fact_team_salaries = df_fact_team_salaries[['team_salary_id'] + df_fact_team_salaries.columns[:-1].tolist()]
df_fact_team_salaries.to_csv('Fact_Team_Salaries.csv', index=False)

print("Generated Fact_Team_Salaries.csv")

# 7. Fact_Standings
df_fact_standings = df_standings.copy()
df_fact_standings['team_id'] = df_fact_standings['team'].map(team_name_to_id)
df_fact_standings['top_scorer_player_id'] = df_fact_standings['top_scorer'].map(player_name_to_id)
df_fact_standings['keeper_player_id'] = df_fact_standings['keeper'].map(player_name_to_id)

df_fact_standings = df_fact_standings.rename(columns={
    'win': 'wins',
    'loss': 'losses',
    'draw': 'draws',
    'goals': 'goals_for',
    'conceded': 'goals_conceded',
    'last5': 'last5_form'
})
df_fact_standings = df_fact_standings[[
    'team_id', 'rank', 'wins', 'losses', 'draws', 'goals_for',
    'goals_conceded', 'points', 'last5_form', 'top_scorer_player_id', 'keeper_player_id'
]]
df_fact_standings['standings_id'] = df_fact_standings.index + 1
df_fact_standings = df_fact_standings[['standings_id'] + df_fact_standings.columns[:-1].tolist()]
df_fact_standings.to_csv('Fact_Standings.csv', index=False)

print("Generated Fact_Standings.csv")
