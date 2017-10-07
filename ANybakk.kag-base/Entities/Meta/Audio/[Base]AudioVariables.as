#include "[Base]AudioSoundtrack.as";
#include "[Base]AmbienceSoundtrack.as";
#include "[Base]UndergroundSoundtrack.as";
#include "[Base]HighSoundtrack.as";



namespace Base {

  namespace AudioVariables {
  
    const string[] MUSIC_TRACKS_DEFAULT = {
      "Sounds/Music/KAGWorld1-1a.ogg",
      "Sounds/Music/KAGWorld1-2a.ogg",
      "Sounds/Music/KAGWorld1-3a.ogg",
      "Sounds/Music/KAGWorld1-4a.ogg",
      "Sounds/Music/KAGWorld1-9a.ogg"
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
    
    //Define an array of music tracks (subtypes can be used, generic should be earlier in the list)
    const Base::AudioSoundtrack@[] SOUND_TRACKS = {
    
      Base::AudioSoundtrack(
        "Default Music",        //name
        "Music",                //groupName
        MUSIC_TRACKS_DEFAULT,   //filePaths
        true,                   //stopOnCriteriaNotMet
        4.0f,                   //fadeoutTime
        4.0f                    //fadeinTime
      ),
    
      Base::AmbienceSoundtrack(
        "Default Ambience",
        "Ambience",
        AMBIENCE_TRACKS_DEFAULT,
        true,
        4.0f,
        4.0f
      ),
    
      Base::UndergroundSoundtrack(
        "Underground Ambience",
        "Ambience",
        AMBIENCE_TRACKS_UNDERGROUND,
        true,
        4.0f,
        4.0f
      ),
    
      Base::HighSoundtrack(
        "High Ambience",
        "Ambience",
        AMBIENCE_TRACKS_HIGH,
        true,
        4.0f,
        4.0f
      )
      
    };
    
    const string MATCH_START_SOUND = "/ResearchComplete.ogg";
    
  }
  
}