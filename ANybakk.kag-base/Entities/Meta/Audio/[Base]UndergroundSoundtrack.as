
#include "[Base]AudioSoundtrack.as"



namespace Base {

  /**
   * An underground soundtrack data structure.
   */
  class UndergroundSoundtrack : Base::AudioSoundtrack {
    
    
    
    UndergroundSoundtrack() {
    
      super();
      
    }
    
    
    
    UndergroundSoundtrack(string name, string groupName, string[] filePaths, bool stopOnCriteriaNotMet, f32 fadeoutTime, f32 fadeinTime) {
    
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
      
      CBlob@ playerBlob = getLocalPlayerBlob();
      
      //Check if valid player blob object
      if(playerBlob !is null) {
      
        //Obtain position
        Vec2f playerPosition = playerBlob.getPosition();
        
        //Return true if below ground
        return map.rayCastSolid(playerPosition, Vec2f(playerPosition.x, playerPosition.y - 60.0f));
        
      }
      
      //Finished, return false
      return false;
      
    }
    
    
    
  }
  
}