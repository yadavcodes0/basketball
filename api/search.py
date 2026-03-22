from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from nba_api.stats.static import players
from nba_api.stats.endpoints import commonplayerinfo, playercareerstats
import time

app = FastAPI(title="NBA API Backend for Flutter")

# Add CORS so Flutter web/emulator can access it easily
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

def get_team_color(team_name: str) -> str:
    """Returns a hex color based on the team name."""
    team_name = team_name.lower()
    colors = {
        "lakers": "0xff552583",
        "warriors": "0xff1d428a",
        "bulls": "0xffce1141",
        "celtics": "0xff007a33",
        "nets": "0xff000000",
        "knicks": "0xfff58426",
        "heat": "0xff98002e",
        "mavericks": "0xff00538c",
        "suns": "0xff1d1160",
        "bucks": "0xff00471b",
        "76ers": "0xff006bb6",
        "clippers": "0xffc1d32f",
        "nuggets": "0xff0e2240",
    }
    for k, v in colors.items():
        if k in team_name:
            return v
    return "0xff1d1160" # Default dark blue/purple

@app.get("/api/search")
@app.get("/")
async def search_players(q: str):
    if not q or len(q) < 2:
        return []
    
    # 1. Find players by name
    found_players = players.find_players_by_full_name(q)
    if not isinstance(found_players, list):
        found_players = []
        
    # Prioritize active players, limit to top 2 to avoid Vercel 10s Serverless timeouts
    active_players = [p for p in found_players if isinstance(p, dict) and p.get('is_active')]
    inactive_players = [p for p in found_players if isinstance(p, dict) and not p.get('is_active')]
    
    top_players = active_players + inactive_players
    if len(top_players) > 2:
        top_players = [top_players[0], top_players[1]]
    
    results = []
    
    for p in top_players:
        player_id = p.get('id')
        name = p.get('full_name')
        if not player_id or not name:
            continue
        
        # High-res official NBA headshot
        image_url = f"https://cdn.nba.com/headshots/nba/latest/1040x760/{player_id}.png"
        
        # Default fallback values for when stats.nba.com blocks Vercel IPs
        team_name = 'Unknown Team'
        position = 'Unknown'
        height = '--'
        weight = '--'
        jersey = '--'
        team_logo = ''
        ppg, apg, rpg, fg_pct, fg3_pct = "0.0", "0.0", "0.0", "0.0", "0.0"
        
        try:
            # 2. Get common player info (position, height, weight, jersey, team)
            info = commonplayerinfo.CommonPlayerInfo(player_id=player_id, timeout=3)
            info_df = info.get_data_frames()[0]
            
            if not info_df.empty:
                row = info_df.iloc[0]
                team_name = row.get('TEAM_NAME', 'Unknown Team')
                position = row.get('POSITION', 'Unknown')
                height = row.get('HEIGHT', '--')
                weight = row.get('WEIGHT', '--')
                if weight != '--': weight = f"{weight} lbs"
                jersey = row.get('JERSEY', '--')
                team_id = row.get('TEAM_ID', 0)
                
                if team_id:
                    team_logo = f"https://cdn.nba.com/logos/nba/{team_id}/primary/L/logo.svg"

            # 3. Get Career/Season Stats
            stats = playercareerstats.PlayerCareerStats(player_id=player_id, timeout=3)
            stats_df = stats.get_data_frames()[0]
            
            if not stats_df.empty:
                # Get the most recent season row
                latest_season = stats_df.iloc[-1]
                gp = latest_season.get('GP', 1)
                if gp == 0: gp = 1 # Avoid division by zero
                
                # Averages
                pts = latest_season.get('PTS', 0)
                ast = latest_season.get('AST', 0)
                reb = latest_season.get('REB', 0)
                
                ppg = f"{(pts / gp):.1f}"
                apg = f"{(ast / gp):.1f}"
                rpg = f"{(reb / gp):.1f}"
                
                # Percentages
                fg = latest_season.get('FG_PCT', 0.0)
                fg3 = latest_season.get('FG3_PCT', 0.0)
                
                fg_pct = f"{(fg * 100):.1f}"
                fg3_pct = f"{(fg3 * 100):.1f}"

        except Exception as e:
            print(f"Error fetching detailed NBA stats for {name}: {e}")
            pass

        # ALWAYS append the player even if the stats timeout/fail!
        bgcolor = get_team_color(team_name)

        results.append({
            "id": player_id,
            "name": name,
            "image": image_url,
            "teamlogo": team_logo,
            "position": position,
            "height": height,
            "weight": weight,
            "jerseyNumber": jersey,
            "team": team_name,
            "ppg": ppg,
            "apg": apg,
            "rpg": rpg,
            "fgPercentage": fg_pct,
            "threePtPercentage": fg3_pct,
            "bgcolorValue": int(bgcolor, 16)
        })
            
    return results

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
