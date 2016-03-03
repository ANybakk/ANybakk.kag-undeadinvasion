
#include "AudioSoundtrack.as"



namespace ANybakk {

  /**
   * A high soundtrack data structure.
   */
  class HighSoundtrack : ANybakk::AudioSoundtrack {
    
    
    
    HighSoundtrack() {
    
      super();
      
    }
    
    
    
    HighSoundtrack(string name, string groupName, string[] filePaths, bool stopOnCriteriaNotMet, f32 fadeoutTime, f32 fadeinTime) {
    
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
        
        //Return true if top fifth of map
        return playerPosition.y < map.tilemapheight * map.tilesize * 0.2f;
        
      }
      
      //Finished, return false
      return false;
      
    }
    
    
    
  }
  
}