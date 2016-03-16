/* 
 * UndeadInvasionAudio blob script
 * 
 * Author: ANybakk
 */
 
#define CLIENT_ONLY

#include "UndeadInvasionAudio.as"



//Called on initialization.
void onInit(CBlob@ this) {

  //Create soundtrack lists
  
  string[] nightTimeSoundtrackList = {
    "Sounds/Music/KAGWorld1-13.ogg"
    //"Sounds/Music/KAGWorld1-14.ogg"
  };
  
  string[] besiegedSurvivorSpawnSoundtrackList = {
    "Sounds/Music/KAGWorld1-10a.ogg"
  };
  
  string[] dayTimeAmbienceSountrackList = {
    "Sounds/Music/ambient_forrest.ogg"
  };

  //Default data

  UndeadInvasionAudio::Data data();
  
  //Configure night-time music
  data.sNightTimeMusicSoundtrack.mName = "Night-time Music";
  data.sNightTimeMusicSoundtrack.mGroupName = "Music";
  data.sNightTimeMusicSoundtrack.mFilePaths = nightTimeSoundtrackList;
  
  //Configure besieged survivor spawn music
  data.sBesiegedSurvivorSpawnMusicSoundtrack.mName = "Besieged Survivor Spawn Music";
  data.sBesiegedSurvivorSpawnMusicSoundtrack.mGroupName = "Music";
  data.sBesiegedSurvivorSpawnMusicSoundtrack.mFilePaths = besiegedSurvivorSpawnSoundtrackList;
  
  //Configure day-time ambience
  data.sDayTimeAmbienceSoundtrack.mName = "Day-time Ambience";
  data.sDayTimeAmbienceSoundtrack.mGroupName = "Ambience";
  data.sDayTimeAmbienceSoundtrack.mFilePaths = dayTimeAmbienceSountrackList;
  
  UndeadInvasionAudio::Blob::storeData(this, @data);
  
  //Audio modifications
  
  Audio::Data@ audioData = Audio::Blob::retrieveData(this);
  audioData.oMatchStartSound = "";
  audioData.oSoundtracks.empty(); //Remove all default soundtracks
  
  //Add music and ambience
  audioData.oSoundtracks.push_back(data.sNightTimeMusicSoundtrack);
  audioData.oSoundtracks.push_back(data.sBesiegedSurvivorSpawnMusicSoundtrack);
  audioData.oSoundtracks.push_back(data.sDayTimeAmbienceSoundtrack);
  audioData.oSoundtracks.push_back(audioData.sHighAmbienceSoundtrack);
  
  
  //Initializations
  
  this.Tag("isUndeadInvasionAudio");
  
}