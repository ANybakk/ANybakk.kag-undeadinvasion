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
  
  //Tag as undead spawn (should normally not be changed)
  this.Tag("isUndeadSpawn");

  //Set an extended nobuild zone of 24.0, 0.0 (3 blocks to the right) to avoid players blocking off (used by DefaultNoBuild.as)
  //this.set_Vec2f("nobuild extend", Vec2f(24.0f, 0.0f));
  
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