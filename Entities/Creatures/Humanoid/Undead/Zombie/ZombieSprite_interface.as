/*
 * UndeadInvasion Zombie entity sprite interface script
 * 
 * This script offers default sprite behaviour for Zombie entities. It is 
 * merely an interface between functions in the ZombieSprite name-space and the 
 * game engine.
 * 
 * Author: ANybakk
 */

#include "ZombieSprite.as";
#include "ZombieVariables.as";



void onInit(CSprite@ this) {

  UndeadInvasion::ZombieSprite::onInit(this);
  
}

void onTick(CSprite@ this) {

  UndeadInvasion::ZombieSprite::onTick(this);
  
}

void onRender(CSprite@ this) {

  UndeadInvasion::ZombieSprite::onRender(this);
  
}

void onGib(CSprite@ this) {

  UndeadInvasion::ZombieSprite::onGib(this);
  
}

