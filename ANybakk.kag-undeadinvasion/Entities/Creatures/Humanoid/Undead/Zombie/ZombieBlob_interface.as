/*
 * Zombie blob interface.
 * 
 * Author: ANybakk
 */

#include "Blob.as"

Blob cBlob;



#include "EntityBlob.as"
//#include "EntityVariables.as"

EntityBlob cEntityBlob;



#include "HumanoidBlob.as"

CreatureBlob cCreatureBlob;



#include "HumanoidBlob.as"

HumanoidBlob cHumanoidBlob;



#include "UndeadBlob.as"
//#include "UndeadVariables.as"

UndeadBlob cUndeadBlob;



#include "ZombieBlob.as"

ZombieBlob cZombieBlob;



void onInit(CBlob@ this) {

  cBlob.onInit(this);
  
  cEntityBlob.onInit(this);
  
  cCreatureBlob.onInit(this);
  
  cHumanoidBlob.onInit(this);
  
  cUndeadBlob.onInit(this);
  
  cZombieBlob.onInit(this);
  
}

bool canBePickedUp(CBlob@ this, CBlob@ other) {
  
  return cUndeadBlob.canBePickedUp(this, other);
  
}

bool doesCollideWithBlob(CBlob@ this, CBlob@ other) {
  
  return cUndeadBlob.doesCollideWithBlob(this, other);

}

void onCollision(CBlob@ this, CBlob@ other, bool solid, Vec2f normal, Vec2f point1) {

  cUndeadBlob.onCollision(this, other, solid, normal, point1);
  
}

void onDie(CBlob@ this) {

  cUndeadBlob.onDie(this);

}

void onChangeTeam(CBlob@ this, const int oldTeam) {

  cEntityBlob.onChangeTeam(this, oldTeam);
  
}