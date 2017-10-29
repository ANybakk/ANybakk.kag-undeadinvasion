/*
 * Producer ingredient blob interface.
 * Unused
 * 
 * Author: ANybakk
 */

#include "[UndeadInvasion]ProductionIngredientBlob.as";



void onInit(CBlob@ this) {
  
  UndeadInvasion::ProductionIngredientBlob::onInit(this);
  
}



bool canBePickedUp(CBlob@ this, CBlob@ byBlob) {
  
  return UndeadInvasion::ProductionIngredientBlob::canBePickedUp(this, byBlob);
  
}



void onAttach(CBlob@ this, CBlob@ attached, AttachmentPoint @attachedPoint) {
  
  UndeadInvasion::ProductionIngredientBlob::onAttach(this, attached, attachedPoint);
  
}



void onDetach(CBlob@ this, CBlob@ detached, AttachmentPoint@ attachedPoint) {
  
  UndeadInvasion::ProductionIngredientBlob::onDetach(this, detached, attachedPoint);
  
}