/* 
 * Camp blob script
 * 
 * Author: ANybakk
 */

#include "Camp.as"
#include "TerritorialBuilding.as"
#include "Entity.as"



//Called on initialization.
void onInit(CBlob@ this) {

  //Default data

  Camp::Data data();
  Camp::Blob::storeData(this, @data);

  //TerritorialBuilding data modifications
  
  TerritorialBuilding::Data@ territorialBuildingData = TerritorialBuilding::Blob::retrieveData(this);
  
  //Entity data modifications
  
  Entity::Data@ entityData = Entity::Blob::retrieveData(this);
  
  //Configure and add ownership event
  entityData.eBlobChangedOwnership.oSound = "/VehicleCapture";
  entityData.eBlobChangedOwnership.oSpriteMode = "occupied";
  entityData.eBlobChangedOwnership.oSpriteState = 0;
  //entityData.eBlobChangedOwnership.oBlobHealth = this.getInitialHealth();       //Full heal on changed ownership
  entityData.oAutoDoOnceEvents.push_back(@(entityData.eBlobChangedOwnership));
  
  //Initializations
  
  this.Tag("isCamp");
  
}