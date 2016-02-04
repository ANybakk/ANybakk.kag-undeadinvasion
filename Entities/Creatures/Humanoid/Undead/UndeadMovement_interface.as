/*
 * UndeadInvasion Undead entity movement interface script
 * 
 * This script offers default movement behaviour for Undead entities. It is 
 * merely an interface between functions in the UndeadMovement name-space and 
 * the game engine.
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