/* 
 * SurvivorSpawnSite blob script
 * 
 * Author: ANybakk
 */

#include "SurvivorSpawnSite.as"



//Called on initialization.
void onInit(CBlob@ this) {

  //Default data

  SurvivorSpawnSite::Data data();
  SurvivorSpawnSite::Blob::storeData(this, @data);
  
  //Data modifications
  
  //Initializations
  
  this.Tag("isSurvivorSpawnSite");
  
}