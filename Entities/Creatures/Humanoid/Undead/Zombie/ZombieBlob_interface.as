/*
 * UndeadInvasion Zombie blob
 * 
 * This script offers default blob behaviour for Zombie entities. It is merely 
 * an interface between functions in the Zombie entity name-space and the game 
 * engine.
 * 
 * NOTE:  This script can be included in the configuration file of a derived 
 *        entity type directly, or included in another script. If some 
 *        functionality needs to be overridden, however, it is better to write 
 *        a new script where you pick what existing functionality you want, or 
 *        provide something else.
 * 
 * NOTE:  If you, as a server administrator, wish to override variables, create 
 *        a new mod where you supply your own version.
 * 
 * Author: ANybakk
 */
 
#include "UndeadBlob.as";
#include "ZombieBlob.as";
#include "ZombieVariables.as";



void onInit(CBlob@ this) {
  
  UndeadInvasion::ZombieBlob::onInit(this);
  
}

void onTick(CBlob@ this) {
  
  UndeadInvasion::UndeadBlob::onTick(this);
  
}

bool canBePickedUp(CBlob@ this, CBlob@ other) {
  
  return UndeadInvasion::UndeadBlob::canBePickedUp(this, other);
  
}

bool doesCollideWithBlob(CBlob@ this, CBlob@ other) {
  
  return UndeadInvasion::UndeadBlob::doesCollideWithBlob(this, other);

}

void onCollision(CBlob@ this, CBlob@ other, bool solid, Vec2f normal, Vec2f point1) {

  UndeadInvasion::UndeadBlob::onCollision(this, other, solid, normal, point1);
  
}

f32 onHit(CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitterBlob, u8 customData) {

  return UndeadInvasion::UndeadBlob::onHit(this, worldPoint, velocity, damage, hitterBlob, customData);
  
}

void onDie(CBlob@ this) {

  UndeadInvasion::UndeadBlob::onDie(this);

}