/*
 * UndeadInvasion Zombie entity brain interface script
 * 
 * This script offers default brain behaviour for Zombie entities. It is merely 
 * an interface between functions in the ZombieBrain name-space and the game 
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

#include "ZombieBrain.as";
#include "ZombieVariables.as";



void onInit(CBrain@ this) {

  UndeadInvasion::ZombieBrain::onInit(this);
  
}

void onTick(CBrain@ this) {

  UndeadInvasion::ZombieBrain::onTick(this);

}