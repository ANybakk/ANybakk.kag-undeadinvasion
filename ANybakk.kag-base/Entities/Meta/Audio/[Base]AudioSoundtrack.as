
#include "[Base]AudioManager.as"



namespace Base {

  /**
   * A basic audio soundtrack data structure. To enable other criteria for 
   * playback, inherit from this class with a different implementation.
   */
  class AudioSoundtrack {
  
  
  
    string mName;
    string mGroupName;
    string[] mFilePaths;
    bool mStopOnCriteriaNotMet;
    f32 mFadeoutTime;
    f32 mFadeinTime;
    
    
    
    AudioSoundtrack() {
    
      mName = "Default Music";
      mGroupName = "Music";
      mFilePaths.push_back("Sounds/Music/KAGWorld1-1a.ogg");
      mStopOnCriteriaNotMet = true;
      mFadeoutTime = 4.0f;
      mFadeinTime = 4.0f;
      
    }
    
    
    
    AudioSoundtrack(string name, string groupName, string[] filePaths, bool stopOnCriteriaNotMet, f32 fadeoutTime, f32 fadeinTime) {
    
      mName = name;
      mGroupName = groupName;
      mFilePaths = filePaths;
      mStopOnCriteriaNotMet = stopOnCriteriaNotMet;
      mFadeoutTime = fadeoutTime;
      mFadeinTime = fadeinTime;
      
    }
    
    
    
    /**
     * Checks if the criteria for playing this soundtrack is met.
     * 
     * @param   audioBlob   a reference to the audio blob object.
     */
    bool meetsCriteria(CBlob@ audioBlob) {
    
      //Create audio manager handle
      Base::AudioManager@ audioManager;
      
      //Check if audio manager could be retrieved
      if(audioBlob.get("AudioManager", @audioManager)) {
      
        //Return true if no tracks with the same group name is playing
        return audioManager.getPlayingCount(mGroupName) == 0;
        
      }
      
      //Finished, return false
      return false;
      
    }
    
    
    
    /**
     * Returns true if this track is group exclusive or not (only one track allowed at a time)
     */
    bool isGroupExclusive() {
    
      return true;
      
    }
    
    
    
  }
  
}