/*
 * Undead movement interface.
 * 
 * Author: ANybakk
 */

#define SERVER_ONLY

#include "UndeadMovement.as";
#include "UndeadVariables.as";



void onInit(CMovement@ this) {

  UndeadInvasion::UndeadMovement::onInit(this);
  
}

void onTick(CMovement@ this) {

  UndeadInvasion::UndeadMovement::onTick(this);
  
}