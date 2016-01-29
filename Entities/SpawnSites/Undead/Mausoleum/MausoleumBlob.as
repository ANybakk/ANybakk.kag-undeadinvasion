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

  //Set an extended nobuild zone of 16.0, 16.0 to avoid players blocking off (used by DefaultNoBuild.as)
  //TODO: Does not seem to be in effect, or area is too small
  this.set_Vec2f("nobuild extend", Vec2f(16.0f, 16.0f));
  
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