/*
 * Producer variables.
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
  
  //Define an array of Undead entities to spawn
  const UndeadInvasion::ProductionOption@[] PRODUCTION_OPTIONS = {
    UndeadInvasion::ProductionOption("Lantern"    , "lantern"   , "Keeps ghosts away"         , PRODUCTION_OPTION_COST_LANTERN    , 1), //1x1 slots
    UndeadInvasion::ProductionOption("Bucket"     , "bucket"    , "A container for liquids"   , PRODUCTION_OPTION_COST_BUCKET     , 1)  //1x1 slots
  };
  
  //Define a flag for whether this producer should have storage enabled
  const bool hasMaterialStorage = true;
  
  //Define a menu size vector
  const Vec2f PRODUCTION_MENU_SIZE(2.0f, 1.0f);
  
}