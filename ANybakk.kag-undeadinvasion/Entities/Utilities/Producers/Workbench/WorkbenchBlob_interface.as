/*
 * Workbench blob interface.
 * 
 * Author: ANybakk
 */

#include "UtilityBlob.as";
#include "ProducerBlob.as";
#include "WorkbenchBlob.as";
#include "WorkbenchVariables.as";



void onInit(CBlob@ this) {
  
  UndeadInvasion::WorkbenchBlob::onInit(this);
  
}



void onTick(CBlob@ this) {
  
  UndeadInvasion::WorkbenchBlob::onTick(this);
  
}



void onCommand(CBlob@ this, u8 cmd, CBitStream @params) {

  UndeadInvasion::ProducerBlob::onCommand(this, cmd, params);
  
}



void GetButtonsFor(CBlob@ this, CBlob@ caller) {

  UndeadInvasion::ProducerBlob::GetButtonsFor(this, caller);
  
}

bool isInventoryAccessible(CBlob@ this, CBlob@ forBlob) {

  return UndeadInvasion::ProducerBlob::isInventoryAccessible(this, forBlob);
  
}



void onSetStatic(CBlob@ this, const bool isStatic) {
  
  UndeadInvasion::UtilityBlob::onSetStatic(this, isStatic);
  
}