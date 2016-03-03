
#include "AudioManager.as"



namespace ANybakk {

  namespace AudioBlob {
  
  
  
    void onInit(CBlob@ this) {
    
      //Create audio manager
      ANybakk::AudioManager audioManager(ANybakk::AudioVariables::SOUND_TRACKS);
      
      //Save audio manager
      this.set("AudioManager", @audioManager);
      
      //Disable match was started flag
      this.Untag("matchWasStarted");
      
    }
    
    
    
    void onTick(CBlob@ this) {
    
      //Create audio manager handle
      ANybakk::AudioManager@ audioManager;
      
      //Check if audio manager could be retrieved
      if(this.get("AudioManager", @audioManager)) {
      
        //Check if sound is enabled and not muted
        if(s_soundon != 0 && s_musicvolume > 0.0f) {
        
          //Retreive a reference to the player blob object
          CBlob @playerBlob = getLocalPlayerBlob();
          
          //Check if invalid player blob object
          if(playerBlob is null) {
          
            //Fade out all
            audioManager.fadeOutAll(0.0f, 6.0f);
            
            //Finished
            return;
            
          }
          
          //Update 
          audioManager.update(this);
          
          //Obtain a reference to the rules object
          CRules@ rules = getRules();
          
          //Check if match is active
          if(rules.isMatchRunning()) {
          
            //Check if match was started flag is disabled
            if(!this.hasTag("matchWasStarted")) {
            
              //Check if match start sound is set
              if(ANybakk::AudioVariables::MATCH_START_SOUND != "") {
              
                //Play game start sound
                //TODO: Move to a sprite script?
                Sound::Play(ANybakk::AudioVariables::MATCH_START_SOUND);
                
              }
              
              //Set flag
              this.Tag("matchWasStarted");
              
            }
            
          }
          
          //Otherwise, check if not warm-up (game ended)
          else if(!rules.isWarmup()){
            
            //Check if playing anything
            if(audioManager.getPlayingCount() >= 0) {

              //Fade out all
              audioManager.fadeOutAll(0.0f, 0.5f);

            }
            
          }
          
        }
        
        //Otherwise (sound off or muted)
        else {
        
          //Fade out all
          audioManager.fadeOutAll(0.0f, 2.0f);
          
        }
        
      }
      
    }
    
    
    
  }
  
}
