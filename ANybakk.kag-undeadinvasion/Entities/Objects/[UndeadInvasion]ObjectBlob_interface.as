/*
 * Object blob interface.
 * 
 * Author: ANybakk
 */

#include "[UndeadInvasion]ObjectBlob.as";
#include "[UndeadInvasion]ObjectVariables.as";



void onInit(CBlob@ this) {

  UndeadInvasion::ObjectBlob::onInit(this);
  
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
