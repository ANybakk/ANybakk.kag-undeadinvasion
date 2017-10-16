/*
 * Forge sprite interface.
 * 
 * Author: ANybakk
 */

#include "[UndeadInvasion]ProducerSprite.as";
#include "[UndeadInvasion]ForgeSprite.as";
#include "[UndeadInvasion]ForgeVariables.as";



void onInit(CSprite@ this) {
  
  UndeadInvasion::ForgeSprite::onInit(this);
  
}

void onTick(CSprite@ this) {
  
  UndeadInvasion::ForgeSprite::onTick(this);
  
}

void onRender(CSprite@ this) {
  
  UndeadInvasion::ProducerSprite::onRender(this);
  
}