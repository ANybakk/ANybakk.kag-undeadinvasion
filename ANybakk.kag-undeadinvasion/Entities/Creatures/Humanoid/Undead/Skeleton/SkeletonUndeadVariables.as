/*
 * Skeleton Undead variables. Derived from UndeadVariables.
 * 
 * Author: ANybakk
 */

#include "UndeadVariables.as"



namespace ANybakk {

  class SkeletonUndeadVariables : UndeadVariables {
  
    SkeletonUndeadVariables() {
    
      ATTACK_DAMAGE                 = 1.0f;               //Normally a whole heart (game mode attack modifier of 0.5)
      COLLATERAL_ATTACK_FREQUENCY   = 1.25f;              //1.25 seconds
      DROP_COIN_AMOUNT              = 1;                  //1 coin (no pockets!)
      BRAIN_DELAY                   = 3;                  //3 frames
      BRAIN_DETECT_RADIUS           = 16.0f;              //Approximately 1 tile in-between
      BRAIN_CHASE_RADIUS            = 32.0f;              //Approximately 2 tiles in-between
      BRAIN_ATTACK_FREQUENCY        = 2.5f;               //Every 2.5 seconds
      MOVEMENT_MAX_VELOCITY         = 0.75f;              //0.75
      MOVEMENT_WALK_ACCELERATION    = Vec2f(3.5f, 0.0f);  //3.5 horisontally
      MOVEMENT_RUN_ACCELERATION     = Vec2f(6.0f, 0.0f);  //6.0 horizontally
      
    }
  
  }
  
}