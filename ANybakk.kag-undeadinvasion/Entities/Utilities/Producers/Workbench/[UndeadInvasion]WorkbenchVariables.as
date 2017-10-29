/*
 * Workbench variables.
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
      UndeadInvasion::ProductionOptionCost("Wood"   , "mat_wood"  , 6)
    , UndeadInvasion::ProductionOptionCost("Iron"   , "mat_iron"  , 6)
    , UndeadInvasion::ProductionOptionCost("Hammer" , "Hammer"    , 1   , false , false)
  };

  const UndeadInvasion::ProductionOptionCost@[] PRODUCTION_OPTION_COST_BUCKET = {
      //Vanilla: 10 Wood
      UndeadInvasion::ProductionOptionCost("Wood"   , "mat_wood"  , 12)
    , UndeadInvasion::ProductionOptionCost("Iron"   , "mat_iron"  , 6)
    , UndeadInvasion::ProductionOptionCost("Hammer" , "Hammer"    , 1   , false , false)
  };

  const UndeadInvasion::ProductionOptionCost@[] PRODUCTION_OPTION_COST_SPONGE = {
      //Vanilla: 50 Wood
      UndeadInvasion::ProductionOptionCost("Wood"   , "mat_wood"  , 6)
  };

  const UndeadInvasion::ProductionOptionCost@[] PRODUCTION_OPTION_COST_HAMMER = {
      UndeadInvasion::ProductionOptionCost("Wood"       , "mat_wood"      , 6)
    , UndeadInvasion::ProductionOptionCost("HammerHead" , "HammerHead"    , 1   , false , true)
  };

  const UndeadInvasion::ProductionOptionCost@[] PRODUCTION_OPTION_COST_BELLOWS = {
      UndeadInvasion::ProductionOptionCost("Wood"   , "mat_wood"  , 12)
    , UndeadInvasion::ProductionOptionCost("Iron"   , "mat_iron"  , 6)
    , UndeadInvasion::ProductionOptionCost("Hammer" , "Hammer"    , 1   , false , false)
  };

  const UndeadInvasion::ProductionOptionCost@[] PRODUCTION_OPTION_COST_TRAMPOLINE = {
      //Vanilla: 150 Wood
      UndeadInvasion::ProductionOptionCost("Wood"   , "mat_wood"  , 24)
    , UndeadInvasion::ProductionOptionCost("Nails"  , "mat_nails" , 6)
    , UndeadInvasion::ProductionOptionCost("Hammer" , "Hammer"    , 1   , false , false)
  };

  const UndeadInvasion::ProductionOptionCost@[] PRODUCTION_OPTION_COST_CRATE = {
      //Vanilla: 30 Wood
      UndeadInvasion::ProductionOptionCost("Wood"   , "mat_wood"  , 24)
    , UndeadInvasion::ProductionOptionCost("Nails"  , "mat_nails" , 12)
    , UndeadInvasion::ProductionOptionCost("Hammer" , "Hammer"    , 1   , false , false)
  };

  const UndeadInvasion::ProductionOptionCost@[] PRODUCTION_OPTION_COST_SAW = {
      //Vanilla: 150 Wood
      UndeadInvasion::ProductionOptionCost("Wood"   , "mat_wood"  , 24)
    , UndeadInvasion::ProductionOptionCost("Nails"  , "mat_nails" , 12)
    , UndeadInvasion::ProductionOptionCost("Hammer" , "Hammer"    , 1   , false , false)
  };

  const UndeadInvasion::ProductionOptionCost@[] PRODUCTION_OPTION_COST_DINGHY = {
      //Vanilla: 150 Wood
      UndeadInvasion::ProductionOptionCost("Wood"   , "mat_wood"  , 90)
    , UndeadInvasion::ProductionOptionCost("Nails"  , "mat_nails" , 24)
    , UndeadInvasion::ProductionOptionCost("Hammer" , "Hammer"    , 1   , false , false)
  };
  
  //Define an array of Undead entities to spawn
  const UndeadInvasion::ProductionOption@[] PRODUCTION_OPTIONS = {
      UndeadInvasion::ProductionOption("Lantern"    , "lantern"   , "Keeps ghosts away"           , 2   , PRODUCTION_OPTION_COST_LANTERN    ) //1x1 slots
    , UndeadInvasion::ProductionOption("Bucket"     , "bucket"    , "A container for liquids"     , 5   , PRODUCTION_OPTION_COST_BUCKET     ) //1x1 slots
    , UndeadInvasion::ProductionOption("Sponge"     , "sponge"    , "Absorbs liquids"             , 2   , PRODUCTION_OPTION_COST_SPONGE     ) //1x1 slots
    , UndeadInvasion::ProductionOption("Hammer"     , "Hammer"    , "A tool used for construction", 5   , PRODUCTION_OPTION_COST_HAMMER     ) //1x1 slots
    , UndeadInvasion::ProductionOption("Bellows"    , "Bellows"   , "A tool used for construction", 10  , PRODUCTION_OPTION_COST_BELLOWS    ) //1x1 slots
    , UndeadInvasion::ProductionOption("Trampoline" , "trampoline", "Bounces objects"             , 10  , PRODUCTION_OPTION_COST_TRAMPOLINE ) //2x1 slots
    , UndeadInvasion::ProductionOption("Crate"      , "crate"     , "A generic container"         , 10  , PRODUCTION_OPTION_COST_CRATE      ) //2x1 slots
    , UndeadInvasion::ProductionOption("Dinghy"     , "dinghy"    , "A simple floatation device"  , 15  , PRODUCTION_OPTION_COST_DINGHY     ) //2x2 slots
    , UndeadInvasion::ProductionOption("Saw"        , "saw"       , "Tool for granulating stuff"  , 20  , PRODUCTION_OPTION_COST_SAW        ) //2x2 slots
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


namespace WorkbenchVariables {

}