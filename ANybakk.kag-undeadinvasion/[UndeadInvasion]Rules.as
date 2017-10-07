/*
 * UndeadInvasion rules script
 * 
 * This script is primarily responsible for initializing the respawn system and 
 * RulesCore.
 * 
 * Author: ANybakk
 */

#define SERVER_ONLY

#include "[Base]Rules.as";

#include "[UndeadInvasion]RulesCore.as";
#include "[UndeadInvasion]RespawnSystem.as";



namespace UndeadInvasion {

  namespace Rules {
  
  
  
    /**
     * Initialization event function.
     */
    void onInit(CRules@ this) {
    
      print("[UndeadInvasion::Rules:onInit]");
      
      Base::Rules::onInit(this);
      
      //Call restart event function
      onRestart(this);
      
      //Finished
      return;
      
    }
    
    
    
    /*
     * Restart event function
     */
    void onRestart(CRules@ this) {
    
      print("[UndeadInvasion::Rules:onRestart]");
      
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