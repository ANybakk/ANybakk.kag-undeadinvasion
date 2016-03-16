/* 
 * Mausoleum blob script
 * 
 * Author: ANybakk
 */

#include "Mausoleum.as"
#include "Entity.as"



//Called on initialization.
void onInit(CBlob@ this) {

  //Default data
  
  Mausoleum::Data data();
  Mausoleum::Blob::storeData(this, @data);
  
  //Entity data modifications
  
  Entity::Data@ entityData = Entity::Blob::retrieveData(this);
  //entityData.eBlobWasDestroyed.oSound = "";
  //entityData.oAutoDoOnceEvents.push_back(@(entityData.eBlobWasDestroyed));
  
  //Initializations
  
  this.Tag("isMausoleum");
  
}