/*
 * UndeadInvasion rules script
 * 
 * This script is primarily responsible for initializing the respawn system and 
 * RulesCore.
 * 
 * Author: ANybakk
 */
 
#define SERVER_ONLY

#include "Rules.as"
#include "UndeadInvasionRulesCore.as"
#include "UndeadInvasionRespawnSystem.as"



/**
 * Initialization event function.
 */
void onInit(CRules@ this) {

  print("[UndeadInvasionRules:onInit]");
  
  ANybakk::Rules::onInit(this);
  
  //Call restart event function
  onRestart(this);
  
  //Finished
  return;
  
}



/*
 * Restart event function
 */
void onRestart(CRules@ this) {

  print("[UndeadInvasionRules:onRestart]");
  
  ANybakk::Rules::onRestart(this);
  
  //Set no timer flag (used by TimeToEnd.as)
  this.set_bool("no timer", true);
  
  //Initialize the re-spawn system
  UndeadInvasionRespawnSystem respawnSystem();
  
  //Initialize the rules core
  UndeadInvasionRulesCore rulesCore(this, respawnSystem);
  
  //Connect rules core
  this.set("core", @rulesCore);
  
  //Finished
  return;
  
}



namespace UndeadInvasion {

  namespace Rules {
  
  
  
  }
  
}