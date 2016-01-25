/*
 * UndeadInvasion rules script
 * 
 * Should replace KAG.as
 * 
 * Author: ANybakk
 * Based on previous work by: Eanmig
 */
#define SERVER_ONLY

#include "UndeadInvasionRulesCore.as";
#include "UndeadInvasionRespawnSystem.as";



/**
 * Initialization event function.
 */
void onInit(CRules@ this) {

  print("[UndeadInvasionRules:onInit]");
  
  //Initialize the re-spawn system
  UndeadInvasionRespawnSystem respawnSystem();
  
  //Initialize the rules core
  UndeadInvasionRulesCore rulesCore(this, respawnSystem);
  
  //Generate a string path to the configuration file
  string configPath = "../Mods/ANybakk.kag-undeadinvasion/Rules/UndeadInvasion/vars.cfg";
  
  //Load configuration file
	ConfigFile cfg = ConfigFile( configPath );
	
  //Determine desired game duration
  s32 gameDuration = cfg.read_s32("game_duration", 0);
  
  //Check if endless game duration
  if (gameDuration <= 0) {
    
    //Register zero duration
    //rulesCore.mGameDuration = 0;
    
    //Set no timer flag
    this.set_bool("no timer", true);
    
  } else {
  
    //Calculate game duration
    //rulesCore.mGameDuration = (getTicksASecond() * 60 * gameDuration); //TODO: Is this variable ever read?
    
  }
	
	//Set maximum number of zombies
  this.set_s32("undead_count_limit", cfg.read_s32("undead_count_limit",125));
  
  //Register player spawn time
  //rulesCore.mSpawnTime = (getTicksASecond() * cfg.read_s32("spawn_time", 30)); //TODO: Is this variable ever read?
  
  //Connect rules core
  this.set("core", @rulesCore);
  
  //Set new start time
  //this.set("start_gametime", getGameTime() + rulesCore.mWarmUpTime);
  
  //Set new end time
  this.set_u32("game_end_time", getGameTime() + gameDuration); //for TimeToEnd.as
  
  //Finished
  return;
  
}



/*
 * Restart event function
 */
void onRestart(CRules@ this) {

  print("[UndeadInvasionRules:onRestart]");
  
}