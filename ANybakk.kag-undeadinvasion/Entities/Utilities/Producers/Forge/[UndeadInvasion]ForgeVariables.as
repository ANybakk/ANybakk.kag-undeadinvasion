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

  const UndeadInvasion::ProductionOptionCost@[] PRODUCTION_OPTION_COST_HAMMERHEAD = {
      UndeadInvasion::ProductionOptionCost("Iron"   , "mat_iron"  , 6)
  };
  
  const UndeadInvasion::ProductionOptionCost@[] PRODUCTION_OPTION_COST_NAILS = {
      UndeadInvasion::ProductionOptionCost("Iron"   , "mat_iron"  , 1)
    , UndeadInvasion::ProductionOptionCost("Hammer" , "Hammer"    , 1   , false , false)
  };

  const UndeadInvasion::ProductionOptionCost@[] PRODUCTION_OPTION_COST_ANVIL = {
      UndeadInvasion::ProductionOptionCost("Iron"   , "mat_iron"  , 24)
    , UndeadInvasion::ProductionOptionCost("Hammer" , "Hammer"    , 1   , false , false)
  };
  
  const UndeadInvasion::ProductionOptionCost@[] PRODUCTION_OPTION_COST_DRILL = {
      //Vanilla: 100 Stone
      UndeadInvasion::ProductionOptionCost("Iron"   , "mat_iron"  , 24)
    , UndeadInvasion::ProductionOptionCost("Hammer" , "Hammer"    , 1   , false , false)
    , UndeadInvasion::ProductionOptionCost("Anvil"  , "Anvil"     , 1   , false , false)
  };
  
  //Define an array of Undead entities to spawn
  const UndeadInvasion::ProductionOption@[] PRODUCTION_OPTIONS = {
      UndeadInvasion::ProductionOption("Hammer Head", "HammerHead", "A vital part of a hammer"      , 5   , PRODUCTION_OPTION_COST_HAMMERHEAD ) //1x1 slots
    , UndeadInvasion::ProductionOption("Nails"      , "mat_nails" , "An important building material", 2   , PRODUCTION_OPTION_COST_NAILS      ) //1x1 slots
    , UndeadInvasion::ProductionOption("Anvil"      , "Anvil"     , "A tool used for construction"  , 10  , PRODUCTION_OPTION_COST_ANVIL      ) //1x1 slots
    , UndeadInvasion::ProductionOption("Drill"      , "drill"     , "A tool for digging faster"     , 15  , PRODUCTION_OPTION_COST_DRILL      ) //2x1 slots
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
  
  //Whether ingredients currently in use (attached) should be visible
  const bool INGREDIENT_INVISIBLE = true;
  
}


namespace ForgeVariables {

}