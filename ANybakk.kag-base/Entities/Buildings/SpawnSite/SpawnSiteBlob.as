/* 
 * SpawnSite blob script
 * 
 * Author: ANybakk
 */

#include "SpawnSite.as"
#include "Building.as"



//Called on initialization.
void onInit(CBlob@ this) {

  //Default data

  SpawnSite::Data data();
  SpawnSite::Blob::storeData(this, @data);
  
  //Building data modifications
  
  Building::Data@ buildingData = Building::Blob::retrieveData(this);
  buildingData.oBackWallType = CMap::tile_castle_back;
  buildingData.oHasWindow = false;
  
  //Initializations
  
  this.Tag("isSpawnSite");
  
}