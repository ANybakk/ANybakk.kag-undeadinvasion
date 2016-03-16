/*
 * Devilish Zombie Undead variables. Derived from UndeadVariables.
 *
 * Author: ANybakk
 */

#include "UndeadVariables.as"



namespace ANybakk {

  class DevilishZombieUndeadVariables : UndeadVariables {
  
    DevilishZombieUndeadVariables() {
    
      ATTACK_DAMAGE                 = 1.5f;               //Normally one and a half a heart (game mode attack modifier of 0.5)
      DROP_COIN_AMOUNT              = 6;                  //6 coins
      BRAIN_DETECT_RADIUS           = 64.0f;              //Approximately 4 tile in-between
      BRAIN_CHASE_RADIUS            = 96.0f;              //Approximately 6 tiles in-between
      
    }
  
  }
  
}