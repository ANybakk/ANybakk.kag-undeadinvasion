/*
 * Forge variables.
 * 
 * Author: ANybakk
 */

#include "[UndeadInvasion]ProductionOptionCost.as";
#include "[UndeadInvasion]ProductionOption.as";



namespace BlobVariables {
  
}

namespace UtilityVariables {

  //Define a flag for removing grass
  const bool REMOVE_GRASS = true;
  
}

namespace ProducerVariables {

  const UndeadInvasion::ProductionOptionCost@[] PRODUCTION_OPTION_COST_DRILL = {
    //Vanilla: 100 Stone
    UndeadInvasion::ProductionOptionCost("Stone", "mat_stone", 90)
  };
  
  //Define an array of Undead entities to spawn
  const UndeadInvasion::ProductionOption@[] PRODUCTION_OPTIONS = {
    UndeadInvasion::ProductionOption("Drill"      , "drill"     , "Tool for digging faster"   , 15  , PRODUCTION_OPTION_COST_DRILL  )  //2x1 slots
  };
  
  //Define a flag for whether this producer should have storage enabled
  const bool hasMaterialStorage = true;
  
  //Define a menu size vector
  const Vec2f PRODUCTION_MENU_SIZE(4.0f, 5.0f);
  
  //Define a flag for enabling the tool menu
  const bool TOOL_MENU_ENABLED = true;
  
  //Define a flag for enabling the stop tool
  const bool TOOL_MENU_STOP_ENABLED = true;
  
  //Define a flag for enabling the repeat tool
  const bool TOOL_MENU_REPEAT_ENABLED = true;
  
  //Define a progress bar width (x: number of world pixels, y: number of screen pixels)
  const Vec2f PROGRESS_BAR_SIZE(16.0f, 6.0f);
  
}


namespace ForgeVariables {

}