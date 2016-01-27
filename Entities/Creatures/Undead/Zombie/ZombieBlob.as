/*
 * UndeadInvasion Zombie blob
 * 
 * This script handles anything general.
 * 
 * Author: ANybakk
 * Based on previous work by: Eanmig
 * 
 * TODO:  Set mode to warm-up when last player leaves (Spawn system's job?)
 */

#include "ZombieVariables.as";

#include "Hitters.as";



/**
 * Initialization event function
 */
void onInit(CBlob@ this) {
  
  //Set to not be in a usual player team
	this.server_setTeamNum(-1);
  
  //Activate brain
  this.getBrain().server_SetActive(true);
  
}



/**
 * Tick event function
 */
void onTick(CBlob@ this) {
  
  //Finished
  
}



/**
 * Hit event function
 */
 /*
f32 onHit(CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitterBlob, u8 customData) {

  //Take damage
  this.Damage(damage, hitterBlob);
  print("DMG recieved:"+damage+" Health:"+this.getHealth());
  //Finished, tell that no damage remains
  return 0.0f;
  
}*/



/**
 * pickup check function
 */
bool canBePickedUp(CBlob@ this, CBlob@ other) {
  
  //Finished, tell that this cannot be picked up
  return false;
  
}



/**
 * Collision check function
 */
bool doesCollideWithBlob(CBlob@ this, CBlob@ other) {
  
  //Finished, tell that this does collide
  return true;

}



/**
 * Collision event function
 * 
 * TODO: Consider if collision should cause a stumbling effect or something
 */
void onCollision(CBlob@ this, CBlob@ other, bool solid, Vec2f normal, Vec2f point1) {

  //Finished
  return;
  
}



/**
 * Death event function
 */
void onDie(CBlob@ this) {

  //Drop coin(s) slightly above current position
  server_DropCoins(this.getPosition() + Vec2f(0,-3.0f), ZombieVariables::DROP_COIN_AMOUNT);
  
  //Initiate gibbing
  this.getSprite().Gib();
  
  //Finished
  return;

}