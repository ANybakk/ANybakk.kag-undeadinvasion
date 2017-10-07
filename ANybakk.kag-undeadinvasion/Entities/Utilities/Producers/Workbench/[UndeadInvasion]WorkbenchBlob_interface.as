/*
 * Workbench blob interface.
 * 
 * Author: ANybakk
 */

#include "[UndeadInvasion]UtilityBlob.as";
#include "[UndeadInvasion]ProducerBlob.as";
#include "[UndeadInvasion]WorkbenchBlob.as";
#include "[UndeadInvasion]WorkbenchVariables.as";



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