
import pandas as pd
import unicodedata
import re
import os

# Define a function to clean player names
def clean_player_name(name):
    if pd.isna(name):
        return ""
    name = unicodedata.normalize('NFKD', str(name)).encode('ascii', 'ignore').decode('ascii')
    name = name.lower()
    name = re.sub(r'[^a-z\s]', '', name)
    return name.strip()

# File names and the player name columns to clean
files_info = {
    "player_possession_stats.csv": "player",
    "player_salaries.csv": "Player",
    "player_stats.csv": "name"
}

# Clean and save each file with a cleaned_player_name column
for file_name, name_column in files_info.items():
    if not os.path.exists(file_name):
        print(f"File not found: {file_name}")
        continue
    df = pd.read_csv(file_name)
    if name_column in df.columns:
        df['cleaned_player_name'] = df[name_column].apply(clean_player_name)
    else:
        df['cleaned_player_name'] = ""
    cleaned_filename = file_name.replace(".csv", "_cleaned.csv")
    df.to_csv(cleaned_filename, index=False)
    print(f"Saved cleaned file: {cleaned_filename}")

# Optional: Clean and fix typos in team_possession_stats.csv
team_file = "team_possession_stats.csv"
if os.path.exists(team_file):
    df_team = pd.read_csv(team_file)
    # Rename typo column if present
    if 'deffensive_touches' in df_team.columns:
        df_team.rename(columns={'deffensive_touches': 'defensive_touches'}, inplace=True)
    df_team.to_csv("team_possession_stats_cleaned.csv", index=False)
    print("Saved cleaned team possession file: team_possession_stats_cleaned.csv")
