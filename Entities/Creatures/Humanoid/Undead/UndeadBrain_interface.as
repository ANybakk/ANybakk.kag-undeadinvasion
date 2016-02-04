/*
 * UndeadInvasion Undead entity brain interface script
 * 
 * This script offers default brain behaviour for Undead entities. It is merely 
 * an interface between functions in the UndeadBrain name-space and the game 
 * engine.
 
 * Author: ANybakk
 * 
 * TODO:  Give undead the ability to change target in BRAINMODE_TARGETING mode, 
 *        if another survivor/animal is closer
 * TODO:  Allow undead to eat meaty food items they may find (steak, burger, 
 *        fish)
 * TODO: Make undead jump if their target in targeting mode is above them.
 */

#define SERVER_ONLY

#include "UndeadBrain.as";
#include "UndeadVariables.as";



void onInit(CBrain@ this) {

  UndeadInvasion::UndeadBrain::onInit(this);
  
}

void onTick(CBrain@ this) {

  UndeadInvasion::UndeadBrain::onTick(this);

}