/*
 * UndeadInvasion SurvivorCamp variables
 * 
 * This script contains any variables associated with the entity. To override 
 * these variables, make a new mod where you override this file. By doing it 
 * this way, tweaking these variables won't require having to deal with code.
 * 
 * Author: ANybakk
 */

namespace SurvivorCampVariables {
  
  const f32 TERRITORY_RADIUS = 150.0f;

  //Define a besieged alert time-out of 3 seconds
  const f32 BESIEGED_RADIUS = 100.0f;

  //Define a besieged alert time-out of 3 seconds
  const u8 BESIEGED_ALERT_TIMEOUT = 3;
  
  //Define a wooden back wall type
  const u32 BACKWALL_TYPE = CMap::tile_wood_back;
  
}