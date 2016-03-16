/* 
 * Night Time Soundtrack
 * 
 * Author: ANybakk
 */

#include "AudioSoundtrack.as"
#include "Rules.as"



/**
 * An underground soundtrack data structure.
 */
class NightTimeSoundtrack : AudioSoundtrack {
  
  
  
  NightTimeSoundtrack() {
  
    super();
    
  }
  
  
  
  NightTimeSoundtrack(string name, string groupName, string[] filePaths, bool stopOnCriteriaNotMet, f32 fadeoutTime, f32 fadeinTime) {
  
    super(name, groupName, filePaths, stopOnCriteriaNotMet, fadeoutTime, fadeinTime);
    
  }
  
  
  
  /**
   * Checks if the criteria for playing this soundtrack is met.
   * 
   * @param   audioBlob   a reference to the audio blob object.
   */
  bool meetsCriteria(CBlob@ audioBlob) override {
  
    //Finished, return true if night time
    return Rules::isNightTime(getRules());
    
  }
  
  
  
}