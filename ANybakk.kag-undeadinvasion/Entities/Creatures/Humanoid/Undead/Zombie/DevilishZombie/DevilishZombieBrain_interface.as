/*
 * Devilish Zombie brain interface.
 
 * Author: ANybakk
 */

#define SERVER_ONLY



#include "UndeadBrain.as";
#include "DevilishZombieUndeadVariables.as" //Derived from UndeadVariables

DevilishZombieUndeadVariables vDevilishZombieUndeadVariables;

UndeadBrain cUndeadBrain(vDevilishZombieUndeadVariables);



void onInit(CBrain@ this) {

  cUndeadBrain.onInit(this);
  
}

void onTick(CBrain@ this) {

  cUndeadBrain.onTick(this);

}