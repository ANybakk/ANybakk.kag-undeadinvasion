/* 
 * Ambience Soundtrack
 * 
 * Author: ANybakk
 */

#include "AudioSoundtrack.as"
#include "UndergroundSoundtrack.as"
#include "HighSoundtrack.as"



namespace AmbienceSoundtrack {

  //Function handle used for delegate calls
  funcdef bool criteria(CBlob@);

}



/**
 * An underground soundtrack data structure.
 */
class AmbienceSoundtrack : AudioSoundtrack {



  UndergroundSoundtrack mUnderground;
  HighSoundtrack mHigh;
  
  
  
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
    AmbienceSoundtrack::criteria@ undergroundMeetsCriteria = AmbienceSoundtrack::criteria(mUnderground.meetsCriteria);
    
    //Create a high soundtrack delegate
    AmbienceSoundtrack::criteria@ highMeetsCriteria = AmbienceSoundtrack::criteria(mHigh.meetsCriteria);
    
    //Return true if underground and high tracks criteria isn't met.
    return !undergroundMeetsCriteria(audioBlob) && !highMeetsCriteria(audioBlob);
    
  }
  
  
  
}