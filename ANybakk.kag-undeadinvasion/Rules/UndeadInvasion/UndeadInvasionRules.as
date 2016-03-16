/*
 * UndeadInvasion rules script
 * 
 * This script is primarily responsible for initializing the respawn system and 
 * RulesCore.
 * 
 * Author: ANybakk
 */

#include "Rules.as"
#include "UndeadInvasionRespawnSystem.as"
#include "UndeadInvasionRulesCore.as"



namespace ANybakk {

  namespace UndeadInvasionRules {
  
  
  
    /**
     * Initialization event function.
     */
    void onInit(CRules@ this) {

      if(g_debug > 0) { print("[UndeadInvasionRules:onInit]"); }
      
      Rules::onInit(this);
      
      //Call restart event function
      onRestart(this);
      
      //Finished
      return;
      
    }
    
    
    
    /*
     * Restart event function
     */
    void onRestart(CRules@ this) {

      if(g_debug > 0) { print("[UndeadInvasionRules:onRestart]"); }
      
      Rules::onRestart(this);
      
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
    
    
    
  }
  
}