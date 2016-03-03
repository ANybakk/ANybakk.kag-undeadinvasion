
#include "AudioSoundtrack.as"



namespace ANybakk {
  
  /**
   * An underground soundtrack data structure.
   */
  class BesiegedSurvivorSpawnSoundtrack : ANybakk::AudioSoundtrack {
    
    
    
    BesiegedSurvivorSpawnSoundtrack() {
    
      super();
      
    }
    
    
    
    BesiegedSurvivorSpawnSoundtrack(string name, string groupName, string[] filePaths, bool stopOnCriteriaNotMet, f32 fadeoutTime, f32 fadeinTime) {
    
      super(name, groupName, filePaths, stopOnCriteriaNotMet, fadeoutTime, fadeinTime);
      
    }
    
    
    
    /**
     * Checks if the criteria for playing this soundtrack is met.
     * 
     * @param   audioBlob   a reference to the audio blob object.
     */
    bool meetsCriteria(CBlob@ audioBlob) override {
    
      //Obtain a reference to the map object
      CMap@ map = audioBlob.getMap();
      
      //Check if map is invalid
      if(map is null) {
      
        return false;
        
      }
      
      //Obtain reference to player blob
      CBlob@ playerBlob = getLocalPlayerBlob();
      
      //Check if valid player blob object
      if(playerBlob !is null) {
      
        //Obtain team number
        int playerTeamNumber = playerBlob.getTeamNum();
        
        //Create blob handle
        CBlob@[] survivorSpawnSites;
        
        //Retrieve references to all survivor spawn sites
        getBlobsByTag("isSurvivorSpawn", @survivorSpawnSites);
        
        //Iterate through any survivor spawns
        for(int i=0; i<survivorSpawnSites.length; i++) {
        
          //Check if on player's team and tagged as besieged
          if(survivorSpawnSites[i].getTeamNum() == playerTeamNumber && survivorSpawnSites[i].hasTag("besieged")) {
          
            //Finished, return true
            return true;
            
          }
          
        }
        
      }
    
      //Finished, return false
      return false;
      
    }
    
    
    
  }
  
}