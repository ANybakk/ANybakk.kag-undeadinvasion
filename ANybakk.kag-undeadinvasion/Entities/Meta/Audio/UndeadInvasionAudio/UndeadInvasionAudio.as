/* 
 * UndeadInvasionAudio
 * 
 * Author: ANybakk
 */

#include "NightTimeSoundtrack.as"
#include "BesiegedSurvivorSpawnSoundtrack.as"
#include "DayTimeSoundtrack.as"



namespace UndeadInvasionAudio {



  const string NAME = "UndeadInvasionAudio";
  
  
  
  shared class Data {
    
    //Options
    
    string                oSomeOption               = "DefaultValue";           //Some option
    
    //Soundtracks

    NightTimeSoundtrack   sNightTimeMusicSoundtrack;
    BesiegedSurvivorSpawnSoundtrack sBesiegedSurvivorSpawnMusicSoundtrack;
    DayTimeSoundtrack     sDayTimeAmbienceSoundtrack;
    
    //Internals
    
  }
  
  
  
  namespace Blob {
  
  
  
    /**
     * Stores a data object
     * 
     * @param   this    a blob pointer.
     * @param   data     a data pointer.
     */
    void storeData(CBlob@ this, Data@ data = null) {

      if(data is null) {
      
        @data = Data();
        
      }
      
      this.set(NAME + "::Data", @data);
      
    }
    
    
    
    /**
     * Retrieves a data object.
     * 
     * @param   this    a blob pointer.
     * @return  data     a pointer to the data (null if none was found).
     */
    Data@ retrieveData(CBlob@ this) {
    
      Data@ data;
      
      this.get(NAME + "::Data", @data);
      
      return data;
      
    }
    
    
    
  }
  
  
  
  namespace Sprite {
  }
  
  
  
  namespace Shape {
  }
  
  
  
  namespace Movement {
  }
  
  
  
  namespace Brain {
  }
  
  
  
  namespace Attachment {
  }
  
  
  
  namespace Inventory {
  }
  
  
}