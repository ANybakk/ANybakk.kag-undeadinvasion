/*
 * UndeadInvasion SurvivorCamp blob
 * 
 * This script handles anything general.
 * 
 * Author: ANybakk
 */

#include "MausoleumVariables.as";


/**
 * Initialization event function
 */
void onInit(CBlob@ this) {
  
  //Finished
  return;
  
}



/**
 * Tick event function
 */
void onTick(CBlob@ this) {
  
  //Finished
  return;

}



/**
 * Command event function
 */
void onCommand(CBlob@ this, u8 cmd, CBitStream @params) {
  
  //Finished
  return;
  
}



/**
 * Hit event function
 */
f32 onHit(CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitterBlob, u8 customData) {

  //Register dealt damage
  this.Damage(damage, hitterBlob);
  
  //Finished (no damage remains)
  return 0.0f;
  
}