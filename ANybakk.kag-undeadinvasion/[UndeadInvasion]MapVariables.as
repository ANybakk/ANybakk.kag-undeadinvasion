/*
 * UndeadInvasion Map variables
 * 
 * Author: ANybakk
 */

namespace UndeadInvasion {

  namespace MapVariables {
  
  
  
    const string[] TILE_HARVEST_BLOB_NAMES = {
        "mat_iron"
      , "mat_aluminium"
      , "mat_coal"
    };
    
    const string[][] TILE_HARVEST_SOUND_FILES = {
        { "dig_stone1.ogg", "dig_stone2.ogg", "dig_stone3.ogg" }
      , { "dig_stone1.ogg", "dig_stone2.ogg", "dig_stone3.ogg" }
      , { "dig_stone1.ogg", "dig_stone2.ogg", "dig_stone3.ogg" }
    };
    
    const string[][] TILE_DEPLETED_SOUND_FILES = {
        { "destroy_stone.ogg" }
      , { "destroy_stone.ogg" }
      , { "destroy_stone.ogg" }
    };
    
    
    const u16[] TILE_ROW_NUMBERS = {
        25  //Iron
      , 26  //Aluminium
      , 27  //Coal
    };
    
    const uint[] TILE_FLAGS = {
        Tile::SOLID | Tile::COLLISION                     //Iron
      , Tile::SOLID | Tile::COLLISION                     //Aluminium
      , Tile::SOLID | Tile::COLLISION | Tile::FLAMMABLE   //Coal
    };
    
    const f32[] TILE_HARVEST_RATIOS = {
        1.0f  //Iron
      , 1.0f  //Aluminium
      , 1.0f  //Coal
    };
  
    //Define a step time for grass growth (in seconds, zero for every tick, negative to disable)
    const f32 GRASS_GROWTH_STEP_TIME = 0.25f;
    
    //Define an amount of grass to (potentially) grow per step
    const u8 GRASS_GROWTH_STEP_AMOUNT = 1;
    
    
    
  }
  
}