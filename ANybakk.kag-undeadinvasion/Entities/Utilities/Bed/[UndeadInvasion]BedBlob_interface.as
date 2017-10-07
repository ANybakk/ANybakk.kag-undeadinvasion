/*
 * Bed blob interface.
 * 
 * Author: ANybakk
 */

#include "[UndeadInvasion]BedBlob.as";
#include "[UndeadInvasion]BedVariables.as";



void onInit(CBlob@ this) {
  
  UndeadInvasion::BedBlob::onInit(this);
  
}



void onTick(CBlob@ this) {
  
  UndeadInvasion::BedBlob::onTick(this);
  
}



void onCommand(CBlob@ this, u8 cmd, CBitStream @params) {

  UndeadInvasion::BedBlob::onCommand(this, cmd, params);
  
}



void GetButtonsFor(CBlob@ this, CBlob@ caller) {

  UndeadInvasion::BedBlob::GetButtonsFor(this, caller);
  
}



void onAttach(CBlob@ this, CBlob@ attached, AttachmentPoint@ attachedPoint) {

  UndeadInvasion::BedBlob::onAttach(this, attached, attachedPoint);
  
}



void onDetach(CBlob@ this, CBlob@ detached, AttachmentPoint@ attachedPoint) {

  UndeadInvasion::BedBlob::onDetach(this, detached, attachedPoint);
  
}