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

#include "[UndeadInvasion]RulesVariables.as";
#include "[UndeadInvasion]DefaultRulesCore.as";
#include "[UndeadInvasion]DefaultRespawnSystem.as";



namespace UndeadInvasion {

  namespace Rules {
  
  
  
    /**
     * Initialization
     */
    void onInit(CRules@ this) {
    
      print("[UndeadInvasion::Rules::onInit]");
      
      Base::Rules::onInit(this);
      
      //Call restart event function
      onRestart(this);
      
      //Finished
      return;
      
    }
    
    
    
    /*
     * Restart
     */
    void onRestart(CRules@ this) {
    
      print("[UndeadInvasion::Rules::onRestart]");
      
      //Set no timer flag (used by TimeToEnd.as)
      this.set_bool("no timer", true);
      
      //Initialize the re-spawn system
      UndeadInvasion::DefaultRespawnSystem respawnSystem();
      
      //Initialize the rules core
      UndeadInvasion::DefaultRulesCore rulesCore(this, respawnSystem);
      
      //Connect rules core
      this.set("core", @rulesCore);
      
      //Finished
      return;
      
    }
    
    
    
    /**
     * State change
     */
    void onStateChange(CRules@ this, const u8 oldState) {
    
      print("[UndeadInvasion::Rules::onStateChange] (oldState=" + oldState + ")");
      
      if(this.getCurrentState() == GAME_OVER) {
      
        this.set_u16("UndeadInvasion::Rules::nextMapCooldown", UndeadInvasion::RulesVariables::NEXT_MAP_COOLDOWN * getTicksASecond());
        
      }
      
    }
    
    
    
    /**
     * Tick
     */
    void onTick(CRules@ this) {
    
      if(this.getCurrentState() == GAME_OVER) {
      
        u16 cooldown = this.get_u16("UndeadInvasion::Rules::nextMapCooldown");
        
        if(cooldown == 0) {
        
          LoadNextMap();
          
        }
        
        else {
        
          this.set_u16("UndeadInvasion::Rules::nextMapCooldown", cooldown-1);
          
        }
        
      }
      
    }
    
    
    
  }
  
}