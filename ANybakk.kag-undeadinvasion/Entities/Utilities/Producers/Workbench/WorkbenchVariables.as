/*
 * Workbench variables.
 * 
 * Author: ANybakk
 */

#include "ProductionOptionCost.as";
#include "ProductionOption.as";



namespace ProducerVariables {

  const UndeadInvasion::ProductionOptionCost@[] PRODUCTION_OPTION_COST_LANTERN = {
    //Vanilla: 10 Wood
    UndeadInvasion::ProductionOptionCost("Wood", "mat_wood", 10)
  };

  const UndeadInvasion::ProductionOptionCost@[] PRODUCTION_OPTION_COST_BUCKET = {
    //Vanilla: 10 Wood
    UndeadInvasion::ProductionOptionCost("Wood", "mat_wood", 30)
  };

  const UndeadInvasion::ProductionOptionCost@[] PRODUCTION_OPTION_COST_SPONGE = {
    //Vanilla: 50 Wood
    UndeadInvasion::ProductionOptionCost("Wood", "mat_wood", 10)
  };

  const UndeadInvasion::ProductionOptionCost@[] PRODUCTION_OPTION_COST_TRAMPOLINE = {
    //Vanilla: 150 Wood
    UndeadInvasion::ProductionOptionCost("Wood", "mat_wood", 60)
  };

  const UndeadInvasion::ProductionOptionCost@[] PRODUCTION_OPTION_COST_CRATE = {
    //Vanilla: 30 Wood
    UndeadInvasion::ProductionOptionCost("Wood", "mat_wood", 60)
  };

  const UndeadInvasion::ProductionOptionCost@[] PRODUCTION_OPTION_COST_DRILL = {
    //Vanilla: 100 Stone
    UndeadInvasion::ProductionOptionCost("Stone", "mat_stone", 90)
  };

  const UndeadInvasion::ProductionOptionCost@[] PRODUCTION_OPTION_COST_SAW = {
    //Vanilla: 150 Wood
    UndeadInvasion::ProductionOptionCost("Wood", "mat_wood", 120)
  };

  const UndeadInvasion::ProductionOptionCost@[] PRODUCTION_OPTION_COST_DINGHY = {
    //Vanilla: 150 Wood
    UndeadInvasion::ProductionOptionCost("Wood", "mat_wood", 90)
  };

  const UndeadInvasion::ProductionOptionCost@[] PRODUCTION_OPTION_COST_BOULDER = {
    //Vanilla: 30 Stone
    UndeadInvasion::ProductionOptionCost("Stone", "mat_stone", 30)
  };
  
  //Define an array of Undead entities to spawn
  const UndeadInvasion::ProductionOption@[] PRODUCTION_OPTIONS = {
    UndeadInvasion::ProductionOption("Lantern"    , "lantern"   , "Keeps ghosts away"         , PRODUCTION_OPTION_COST_LANTERN    , 2), //1x1 slots
    UndeadInvasion::ProductionOption("Bucket"     , "bucket"    , "A container for liquids"   , PRODUCTION_OPTION_COST_BUCKET     , 5), //1x1 slots
    UndeadInvasion::ProductionOption("Sponge"     , "sponge"    , "Absorbs liquids"           , PRODUCTION_OPTION_COST_SPONGE     , 2), //1x1 slots
    UndeadInvasion::ProductionOption("Boulder"    , "boulder"   , "A heavy object"            , PRODUCTION_OPTION_COST_BOULDER    , 5), //1x1 slots
    UndeadInvasion::ProductionOption("Trampoline" , "trampoline", "Bounces objects"           , PRODUCTION_OPTION_COST_TRAMPOLINE , 10), //2x1 slots
    UndeadInvasion::ProductionOption("Crate"      , "crate"     , "A generic container"       , PRODUCTION_OPTION_COST_CRATE      , 10), //2x1 slots
    UndeadInvasion::ProductionOption("Dinghy"     , "dinghy"    , "A simple floatation device", PRODUCTION_OPTION_COST_DINGHY     , 15), //2x2 slots
    UndeadInvasion::ProductionOption("Saw"        , "saw"       , "Tool for granulating stuff", PRODUCTION_OPTION_COST_SAW        , 20), //2x2 slots
    UndeadInvasion::ProductionOption("Drill"      , "drill"     , "Tool for digging faster"   , PRODUCTION_OPTION_COST_DRILL      , 15)  //2x1 slots
  };
  
  //Define a flag for whether this producer should have storage enabled
  const bool hasMaterialStorage = true;
  
  //Define a menu size vector
  const Vec2f PRODUCTION_MENU_SIZE(4.0f, 5.0f);
  
}


namespace WorkbenchVariables {

}