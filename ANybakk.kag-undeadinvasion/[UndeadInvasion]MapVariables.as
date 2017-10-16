/*
 * UndeadInvasion Map variables
 * 
 * Author: ANybakk
 */

namespace UndeadInvasion {

  namespace MapVariables {
  
    const TileType TILE_OFFSET_START = 384; //Row 25
  
    //Iron tile
    const TileType[] TILE_OFFSETS_IRON = {
      TILE_OFFSET_START, 385, 386, 387, 388, 389  //Variants
      , 390, 391, 392, 393, 394     //States
    };
    const uint TILE_FLAGS_IRON =
      Tile::SOLID
      | Tile::COLLISION
      //| Tile::BACKGROUND
      //| Tile::LADDER
      //| Tile::LIGHT_PASSES
      //| Tile::WATER_PASSES
      //| Tile::FLAMMABLE
      //| Tile::PLATFORM
      //| Tile::LIGHT_SOURCE
    ;
    const f32 TILE_HARVEST_RATIO_IRON = 1.0f; //Equal to incoming damage
  
    //Aluminium tile
    const TileType[] TILE_OFFSETS_ALUMINIUM = {
      400, 401, 402, 403, 404, 405  //Variants (Row 26)
      , 406, 407, 408, 409, 410     //States
    };
    const uint TILE_FLAGS_ALUMINIUM =
      Tile::SOLID
      | Tile::COLLISION
    ;
    const f32 TILE_HARVEST_RATIO_ALUMINIUM = 1.0f; //Equal to incoming damage
  
    //Coal tile
    const TileType[] TILE_OFFSETS_COAL = {
      416, 417, 418, 419, 420, 421  //Variants (Row 27)
      , 422, 423, 424, 425, 426     //States
    };
    const uint TILE_FLAGS_COAL =
      Tile::SOLID
      | Tile::COLLISION
      | Tile::FLAMMABLE
    ;
    const f32 TILE_HARVEST_RATIO_COAL = 1.0f; //Equal to incoming damage
    
    const TileType[][] TILE_OFFSETS = {
      TILE_OFFSETS_IRON,
      TILE_OFFSETS_ALUMINIUM,
      TILE_OFFSETS_COAL
    };
    
  }
  
}