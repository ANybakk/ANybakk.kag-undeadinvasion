/* 
 * Audio Manager
 * 
 * Author: ANybakk
 */

#include "AudioSoundtrack.as"



class AudioManager {



  CMixer@ mMixer;
  AudioSoundtrack@[] mSoundtracks; //Not allowed to refer a whole array for some reason
  
  
  
  AudioManager() {
  
    //Obtain a reference to the mixer object
    @mMixer = getMixer();
    
    //Check if valid mixer
    if(mMixer !is null) {
    
      //Reset mixer
      mMixer.ResetMixer();
      
    }
    
  }
  
  
  
  AudioManager(AudioSoundtrack@[] soundtracks) {
    
    //Keep a reference to the tracks
    mSoundtracks = soundtracks;
  
    //Keep a reference to the mixer object
    @mMixer = getMixer();
    
    //Check if valid mixer
    if(mMixer !is null) {
    
      //Reset mixer
      mMixer.ResetMixer();
      
      //Iterate through all music tracks
      for(int i=0; i<mSoundtracks.length; i++) {
        
        //Iterate through all file paths
        for(int j=0; j<mSoundtracks[i].mFilePaths.length; j++) {
        
          //Add track
          mMixer.AddTrack(mSoundtracks[i].mFilePaths[j], i);
          
        }
        
      }
      
    }
    
  }
  
  
  
  /**
   * Performs update based on each track's criteria. Plays tracks that do.
   * 
   * @param   audioBlob   a reference to the relevant audio blob object.
   */
  void update(CBlob@ audioBlob) {
    
    //Iterate through all tracks
    for(int i=0; i<mSoundtracks.length; i++) {
      
      //Check if criteria is met
      if(mSoundtracks[i].meetsCriteria(@audioBlob)) {
      
        //Play track
        playTrack(i);
        
      }
      
      //Otherwise, criteria not met
      else {
      
        //Check if allowed to stop
        if(mSoundtracks[i].mStopOnCriteriaNotMet) {
        
          //Stop track
          stopTrack(i);
          
        }
        
      }
      
    }
    
    //Finished
    return;
  
  }
  
  
  
  /**
   * Plays a track (if not already playing). Stops other tracks in the same 
   * group if set to group exclusive.
   * 
   * @param   i     the index of the track to start.
   */
  void playTrack(int i) {
    
    //Check if valid mixer
    if(mMixer !is null) {
    
      //Check if not already playing
      if(!mMixer.isPlaying(i)) {
      
        //Fade in new track
        mMixer.FadeInRandom(i, mSoundtracks[i].mFadeinTime);
        
      }
      
      //Check if set as group exclusive (no other group tracks allowed)
      if(mSoundtracks[i].isGroupExclusive()) {
      
        //Iterate through all tracks
        for(int j = 0; j < mSoundtracks.length; j++) {
          
          //Check if not new track and same group
          if(j != i && mSoundtracks[j].mGroupName == mSoundtracks[i].mGroupName) {
          
            //Check if playing
            if(mMixer.isPlaying(j)) {
            
              //Fade out
              mMixer.FadeOut(j, mSoundtracks[j].mFadeoutTime);
              
            }
          
          }
        
        }
        
      }
      
    }
    
    //Finished
    return;
    
  }
  
  
  
  /**
   * Stops playing a track (if playing)
   * 
   * @param   i     the index of the track to start.
   */
  void stopTrack(int i) {
    
    //Check if valid mixer
    if(mMixer !is null) {
    
      //Check if playing
      if(mMixer.isPlaying(i)) {
      
        //Fade out track
        mMixer.FadeOut(i, mSoundtracks[i].mFadeoutTime);
        
      }
      
    }
    
    //Finished
    return;
    
  }
  
  
  
  /**
   * Returns the number of tracks currently being played.
   * 
   * @param   groupName   an optional group game to limit result to a specific group.
   */
  int getPlayingCount(string groupName = "") {
    
    //Check if invalid mixer
    if(mMixer is null) {
    
      //Finished
      return 0;
      
    }
    
    //Check if no group name
    if(groupName == "") {
    
      //Return play count from mixer
      return mMixer.getPlayingCount();
      
    }
    
    //Otherwise
    else {
    
      int result = 0;
      
      AudioSoundtrack@ soundTrack;
      
      //Iterate through all tracks
      for(int i = 0; i < mSoundtracks.length; i++) {
      
        @soundTrack = mSoundtracks[i];
        
        //Check if in correct group
        if(soundTrack.mGroupName == groupName) {
        
          //Check if playing
          if(mMixer.isPlaying(i)) {
          
            result++;
          
          }
        
        }
        
      }
      
      //Finished, return result
      return result;
      
    }
    
    //Finished
    return 0;
    
  }
  
  
  
  /**
   * Fades out all tracks
   */
  void fadeOutAll(f32 time1, f32 time2) {
  
    //Check if valid mixer
    if(mMixer !is null) {
    
      //Fade out everything
      mMixer.FadeOutAll(time1, time2);
      
    }
    
  }
  
  
  
}