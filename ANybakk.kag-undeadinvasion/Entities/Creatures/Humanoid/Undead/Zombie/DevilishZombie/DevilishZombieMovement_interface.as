/*
 * Devilish Zombie movement interface.
 * 
 * Author: ANybakk
 */

#define SERVER_ONLY



#include "UndeadMovement.as";
#include "DevilishZombieUndeadVariables.as" //Derived from UndeadVariables

DevilishZombieUndeadVariables vDevilishZombieUndeadVariables;

UndeadMovement cUndeadMovement(vDevilishZombieUndeadVariables);



void onInit(CMovement@ this) {

  cUndeadMovement.onInit(this);
  
}

void onTick(CMovement@ this) {

  cUndeadMovement.onTick(this);
  
}