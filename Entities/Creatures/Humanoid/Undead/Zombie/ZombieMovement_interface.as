/*
 * UndeadInvasion Zombie entity movement interface script
 * 
 * This script offers default movement behaviour for Zombie entities. It is 
 * merely an interface between functions in the ZombieMovement name-space and 
 * the game engine.
 * 
 * Author: ANybakk
 */

#define SERVER_ONLY

#include "ZombieMovement.as";
#include "ZombieVariables.as";



void onInit(CMovement@ this) {

  UndeadInvasion::ZombieMovement::onInit(this);
  
}

void onTick(CMovement@ this) {

  UndeadInvasion::ZombieMovement::onTick(this);
  
}