/*
 * Log blob interface.
 * 
 * Author: ANybakk
 */

#include "[UndeadInvasion]ObjectBlob.as";
#include "[UndeadInvasion]LogBlob.as";
#include "[UndeadInvasion]LogVariables.as";



void onInit(CBlob@ this) {

  UndeadInvasion::LogBlob::onInit(this);
  
}

bool doesCollideWithBlob(CBlob@ this, CBlob@ blob) {

  return UndeadInvasion::ObjectBlob::doesCollideWithBlob(this, blob);
  
}

void onDetach(CBlob@ this, CBlob@ detached, AttachmentPoint@ attachedPoint) {

  UndeadInvasion::ObjectBlob::onDetach(this, detached, attachedPoint);
  
}

void onCollision(CBlob@ this, CBlob@ blob, bool solid) {

  UndeadInvasion::ObjectBlob::onCollision(this, blob, solid);
  
}
