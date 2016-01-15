/*
 * UndeadInvasion mode script
 * 
 * Author: ANybakk
 * Based on previous work by: Eanmig
 */
#define SERVER_ONLY

#include "UndeadInvasionRulesCore.as";
#include "UndeadInvasionRespawnSystem.as";



/*
 * Restart function (hook?)
 */
void onRestart(CRules@ rules) {
  
  //Initialize the re-spawn system
  UndeadInvasionRespawnSystem respawnSystem();
  
  //Initialize the rules core
  UndeadInvasionRulesCore rulesCore(rules, respawnSystem());
  
  //Generate a string path to the configuration file
  string configPath = "../Mods/" + sv_gamemode + "/Rules/" + sv_gamemode + "/vars.cfg";
  
  //Load configuration file
	ConfigFile cfg = ConfigFile( configPath );
	
  //Determine desired game duration
  s32 gameDuration = cfg.read_s32("game_duration", 0);
  
  //Check if endless game duration
  if (gameDuration <= 0) {
    
    //Register zero duration
    rulesCore.mGameDuration = 0;
    
    //Set no timer flag
    rules.set_bool("no timer", true);
    
  } else {
  
    //Calculate game duration
    rulesCore.mGameDuration = (getTicksASecond() * 60 * gameDuration); //TODO: Is this variable ever read?
    
  }
	
	//Set maximum number of zombies
  rules.set_s32("undead_count_limit", cfg.read_s32("undead_count_limit",125));
  
  //Register player spawn time
  rulesCore.mSpawnTime = (getTicksASecond() * cfg.read_s32("spawn_time", 30)); //TODO: Is this variable ever read?
  
  //Connect rules core
  rules.set("core", @rulesCore);
  
  //Set new start time
  rules.set("start_gametime", getGameTime() + rulesCore.mWarmUpTime);
  
  //Set new end time
  rules.set_u32("game_end_time", getGameTime() + rulesCore.mGameDuration); //for TimeToEnd.as
  
}


/*
void spawnPortal(Vec2f pos)
{
	server_CreateBlob("ZombiePortal",-1,pos+Vec2f(0,-24.0));
}
*/