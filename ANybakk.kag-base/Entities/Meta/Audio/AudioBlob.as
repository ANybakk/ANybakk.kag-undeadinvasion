/* 
 * Audio blob script
 * 
 * Author: ANybakk
 */

#define CLIENT_ONLY

#include "Audio.as"
#include "AudioManager.as"



//Called on initialization.
void onInit(CBlob@ this) {

  //Create soundtrack lists
  
  string[] defaultSoundtrackList = {
    "Sounds/Music/KAGWorld1-1a.ogg",
    "Sounds/Music/KAGWorld1-2a.ogg",
    "Sounds/Music/KAGWorld1-3a.ogg",
    "Sounds/Music/KAGWorld1-4a.ogg",
    "Sounds/Music/KAGWorld1-9a.ogg"
  };
  
  string[] defaultAmbienceSoundtrackList = {
    "Sounds/Music/ambient_forrest.ogg"
  };
  
  string[] undergroundAmbienceSountrackList = {
    "Sounds/Music/ambient_cavern.ogg"
  };
  
  string[] highAmbienceSoundtrackList  = {
    "Sounds/Music/ambient_mountain.ogg"
  };
  
  //Default data
  
  Audio::Data data();
  
  //Configure and add default music
  data.sDefaultMusicSoundtrack.mFilePaths = defaultSoundtrackList;
  data.oSoundtracks.push_back(data.sDefaultMusicSoundtrack);
  
  //Configure and add default ambience
  data.sDefaultAmbienceSoundtrack.mName = "Default Ambience";
  data.sDefaultAmbienceSoundtrack.mGroupName = "Ambience";
  data.sDefaultAmbienceSoundtrack.mFilePaths = defaultAmbienceSoundtrackList;
  data.oSoundtracks.push_back(data.sDefaultAmbienceSoundtrack);
  
  //Configure and add underground ambience
  data.sUndergroundAmbienceSoundtrack.mName = "Underground Ambience";
  data.sUndergroundAmbienceSoundtrack.mGroupName = "Ambience";
  data.sUndergroundAmbienceSoundtrack.mFilePaths = undergroundAmbienceSountrackList;
  data.oSoundtracks.push_back(data.sUndergroundAmbienceSoundtrack);
  
  //Configure and add high ambience
  data.sHighAmbienceSoundtrack.mName = "High Ambience";
  data.sHighAmbienceSoundtrack.mGroupName = "Ambience";
  data.sHighAmbienceSoundtrack.mFilePaths = highAmbienceSoundtrackList;
  data.oSoundtracks.push_back(data.sHighAmbienceSoundtrack);
  
  //Store data object
  Audio::Blob::storeData(this, @data);
  
  //Audio Manager
  
  AudioManager@ audioManager = AudioManager(data.SOUND_TRACKS);
  this.set("AudioManager", @audioManager);
  
  //Initialization
  
  this.Tag("isAudio");
  
}



//Called on every tick.
void onTick(CBlob@ this) {

  //Create audio manager handle
  AudioManager@ audioManager;
  
  //Check if audio manager could be retrieved
  if(this.get("AudioManager", @audioManager)) {
  
    //Retrieve data
    Audio::Data@ data = Audio::Blob::retrieveData(this);
  
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
        if(!data.iMatchWasStarted) {
        
          //Check if match start sound is set
          if(data.oMatchStartSound != "") {
          
            //Play game start sound
            //TODO: Move to a sprite script?
            Sound::Play(data.oMatchStartSound);
            
          }
          
          //Set flag
          data.iMatchWasStarted = true;
          
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