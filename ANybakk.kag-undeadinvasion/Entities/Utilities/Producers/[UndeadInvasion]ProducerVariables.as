/*
 * Producer variables.
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

  const UndeadInvasion::ProductionOptionCost@[] PRODUCTION_OPTION_COST_LANTERN = {
    //Vanilla: 10 Wood
    UndeadInvasion::ProductionOptionCost("Wood", "mat_wood", 10)
  };

  const UndeadInvasion::ProductionOptionCost@[] PRODUCTION_OPTION_COST_BUCKET = {
    //Vanilla: 10 Wood
    UndeadInvasion::ProductionOptionCost("Wood", "mat_wood", 30)
  };
  
  //Define an array of Undead entities to spawn
  const UndeadInvasion::ProductionOption@[] PRODUCTION_OPTIONS = {
    UndeadInvasion::ProductionOption("Lantern"    , "lantern"   , "Keeps ghosts away"         , PRODUCTION_OPTION_COST_LANTERN    , 1), //1x1 slots
    UndeadInvasion::ProductionOption("Bucket"     , "bucket"    , "A container for liquids"   , PRODUCTION_OPTION_COST_BUCKET     , 1)  //1x1 slots
  };
  
  //Define a flag for whether this producer should have storage enabled
  const bool hasMaterialStorage = true;
  
  //Define a menu size vector
  const Vec2f PRODUCTION_MENU_SIZE(2.0f, 1.0f);
  
  //Define a flag for enabling the tool menu
  const bool TOOL_MENU_ENABLED = true;
  
  //Define a flag for enabling the stop tool
  const bool TOOL_MENU_STOP_ENABLED = true;
  
  //Define a flag for enabling the repeat tool
  const bool TOOL_MENU_REPEAT_ENABLED = true;
  
  //Define a progress bar width
  const Vec2f PROGRESS_BAR_SIZE(16, 3);
  
  
}