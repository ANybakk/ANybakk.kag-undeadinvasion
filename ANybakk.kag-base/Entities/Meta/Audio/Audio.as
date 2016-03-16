/* 
 * Audio
 * 
 * Author: ANybakk
 */

#include "AudioSoundtrack.as";
#include "AmbienceSoundtrack.as";
#include "UndergroundSoundtrack.as";
#include "HighSoundtrack.as";



namespace Audio {



  const string NAME = "Audio";
  
  
  
  class Data {
    
    //Options
    
    string                oMatchStartSound          = "/ResearchComplete.ogg";
    AudioSoundtrack@[]    oSoundtracks;                                         //Define an array of music tracks (subtypes can be used, generic should be earlier in the list)
    
    //Soundtracks

    AudioSoundtrack       sDefaultMusicSoundtrack;
    AmbienceSoundtrack    sDefaultAmbienceSoundtrack;
    UndergroundSoundtrack sUndergroundAmbienceSoundtrack;
    HighSoundtrack        sHighAmbienceSoundtrack;
    
    //Internals
    
    bool                  iMatchWasStarted          = false;
    
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