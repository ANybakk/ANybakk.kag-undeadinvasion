/*
 * Zombie sprite interface.
 * 
 * Author: ANybakk
 */

#include "EntitySprite.as"
//#include "EntityVariables.as"

EntitySprite cEntitySprite;



#include "UndeadSprite.as";
//#include "UndeadVariables.as"

UndeadSprite cUndeadSprite;



#include "ZombieSprite.as";

ZombieSprite cZombieSprite;



void onInit(CSprite@ this) {

  cEntitySprite.onInit(this);

  cUndeadSprite.onInit(this);
  
}

void onTick(CSprite@ this) {

  cEntitySprite.onTick(this);

  cUndeadSprite.onTick(this);
  
}

void onRender(CSprite@ this) {

  cUndeadSprite.onRender(this);
  
}

void onGib(CSprite@ this) {

  cZombieSprite.onGib(this);
  
}