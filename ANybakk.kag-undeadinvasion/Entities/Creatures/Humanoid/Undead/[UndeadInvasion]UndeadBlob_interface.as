/*
 * Undead blob interface.
 * 
 * Author: ANybakk
 
 * TODO: Idea: Create player-controlled Undead entities
 * TODO: Consider custom "corpse" block on death by spikes etc., (use server_SetTile(Vec2f, Tile))
 * TODO: Consider letting undead dig through dirt if they smell flesh (lower ranges than above-ground perception)
 */
 
#include "[UndeadInvasion]UndeadBlob.as";
#include "[UndeadInvasion]UndeadVariables.as";



void onInit(CBlob@ this) {
  
  UndeadInvasion::UndeadBlob::onInit(this);
  
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