/*
 * Undead blob interface.
 * 
 * Author: ANybakk
 
 * TODO: Idea: Create player-controlled Undead entities
 * TODO: Consider custom "corpse" block on death by spikes etc., (use server_SetTile(Vec2f, Tile))
 * TODO: Consider letting undead dig through dirt if they smell flesh (lower ranges than above-ground perception)
 */

#include "Blob.as"

Blob cBlob;



#include "EntityBlob.as"
//#include "EntityVariables.as"

EntityBlob cEntityBlob;



#include "CreatureBlob.as"

CreatureBlob cCreatureBlob;



#include "HumanoidBlob.as"

HumanoidBlob cHumanoidBlob;



#include "UndeadBlob.as"
#include "SkeletonUndeadVariables.as" //Derived from UndeadVariables

SkeletonUndeadVariables vSkeletonUndeadVariables;

UndeadBlob cUndeadBlob(vSkeletonUndeadVariables);



#include "SkeletonBlob.as"

SkeletonBlob cSkeletonBlob;



void onInit(CBlob@ this) {

  cBlob.onInit(this);
  
  cEntityBlob.onInit(this);
  
  cCreatureBlob.onInit(this);
  
  cHumanoidBlob.onInit(this);
  
  cUndeadBlob.onInit(this);
  
  cSkeletonBlob.onInit(this);
  
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