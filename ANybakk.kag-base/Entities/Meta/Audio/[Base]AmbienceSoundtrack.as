
#include "[Base]AudioSoundtrack.as"
#include "[Base]UndergroundSoundtrack.as"
#include "[Base]HighSoundtrack.as"


namespace Base {

  namespace AmbienceSoundtrack {
  
    //Function handle used for delegate calls
    funcdef bool criteria(CBlob@);
  
  }
  
  /**
   * An underground soundtrack data structure.
   */
  class AmbienceSoundtrack : Base::AudioSoundtrack {
  
  
  
    Base::UndergroundSoundtrack mUnderground;
    Base::HighSoundtrack mHigh;
    
    
    
    AmbienceSoundtrack() {
    
      super();
      
    }
    
    
    
    AmbienceSoundtrack(string name, string groupName, string[] filePaths, bool stopOnCriteriaNotMet, f32 fadeoutTime, f32 fadeinTime) {
    
      super(name, groupName, filePaths, stopOnCriteriaNotMet, fadeoutTime, fadeinTime);
      
    }
    
    
    
    /**
     * Checks if the criteria for playing this soundtrack is met.
     * 
     * @param   audioBlob   a reference to the audio blob object.
     */
    bool meetsCriteria(CBlob@ audioBlob) override {
    
      //Create an underground soundtrack delegate
      criteria@ undergroundMeetsCriteria = criteria(mUnderground.meetsCriteria);
      
      //Create a high soundtrack delegate
      criteria@ highMeetsCriteria = criteria(mHigh.meetsCriteria);
    
      //Return true if underground and high tracks criteria isn't met.
      return !undergroundMeetsCriteria(audioBlob) && !highMeetsCriteria(audioBlob);
      
    }
    
    
    
  }
  
}