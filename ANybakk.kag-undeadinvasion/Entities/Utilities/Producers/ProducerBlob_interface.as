/*
 * Producer blob interface.
 * 
 * Author: ANybakk
 */

#include "ProducerBlob.as";
#include "ProducerVariables.as";



void onInit(CBlob@ this) {
  
  UndeadInvasion::ProducerBlob::onInit(this);
  
}



void onTick(CBlob@ this) {
  
  UndeadInvasion::ProducerBlob::onTick(this);
  
}



void onCommand(CBlob@ this, u8 commandID, CBitStream @argumentStream) {
  
  UndeadInvasion::ProducerBlob::onCommand(this, commandID, argumentStream);
  
}



bool isInventoryAccessible(CBlob@ this, CBlob@ userBlob) {
  
  UndeadInvasion::ProducerBlob::isInventoryAccessible(this, userBlob);
  
}



void GetButtonsFor(CBlob@ this, CBlob@ userBlob) {
  
  UndeadInvasion::ProducerBlob::GetButtonsFor(this, userBlob);
  
}