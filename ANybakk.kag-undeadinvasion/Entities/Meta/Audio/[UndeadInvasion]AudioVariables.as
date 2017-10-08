#include "[Base]AudioSoundtrack.as"
#include "[Base]NighttimeSoundtrack.as"
#include "[Base]DaytimeSoundtrack.as"
#include "[Base]UndergroundSoundtrack.as"
#include "[Base]HighSoundtrack.as"

#include "[UndeadInvasion]BesiegedSurvivorSpawnSoundtrack.as"



namespace Base {

  namespace AudioVariables {
  
    const string[] MUSIC_TRACKS_NIGHTTIME = {
      "Sounds/Music/KAGWorld1-13.ogg"
      //"Sounds/Music/KAGWorld1-14.ogg"
    };
  
    const string[] MUSIC_TRACKS_BESIEGED_SURVIVOR_SPAWN = {
      "Sounds/Music/KAGWorld1-10a.ogg"
    };
  
    const string[] AMBIENCE_TRACKS_DEFAULT = {
      "Sounds/Music/ambient_forrest.ogg"
    };
  
    const string[] AMBIENCE_TRACKS_UNDERGROUND = {
      "Sounds/Music/ambient_cavern.ogg"
    };
  
    const string[] AMBIENCE_TRACKS_HIGH = {
      "Sounds/Music/ambient_mountain.ogg"
    };
    
    //Define an array of music tracks
    const Base::AudioSoundtrack@[] SOUND_TRACKS = {
    
      Base::NightTimeSoundtrack(
        "Night-time Music",
        "Music",
        MUSIC_TRACKS_NIGHTTIME,
        true,
        4.0f,
        4.0f
      ),
    
      Base::BesiegedSurvivorSpawnSoundtrack(
        "Besieged Survivor Spawn Music",
        "Music",
        MUSIC_TRACKS_BESIEGED_SURVIVOR_SPAWN,
        true,
        4.0f,
        4.0f
      ),
    
      Base::DayTimeSoundtrack(
        "Day-time Ambience",
        "Ambience",
        AMBIENCE_TRACKS_DEFAULT,
        true,
        4.0f,
        4.0f
      ),
      
      /*
      Base::UndergroundSoundtrack(
        "Underground Ambience",
        "Ambience",
        AMBIENCE_TRACKS_UNDERGROUND,
        true,
        4.0f,
        4.0f
      ),
      */
      
      Base::HighSoundtrack(
        "High Ambience",
        "Ambience",
        AMBIENCE_TRACKS_HIGH,
        true,
        4.0f,
        4.0f
      )
      
    };
    
    const string MATCH_START_SOUND = "";
    
  }

}

namespace UndeadInvasion {

  namespace AudioVariables {
  
    
    
  }
  
}