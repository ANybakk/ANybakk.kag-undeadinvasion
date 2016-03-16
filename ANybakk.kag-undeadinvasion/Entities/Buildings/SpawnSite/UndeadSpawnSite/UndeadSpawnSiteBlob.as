/* 
 * UndeadSpawnSite blob script
 * 
 * Author: ANybakk
 */

#include "UndeadSpawnSite.as"



//Called on initialization.
void onInit(CBlob@ this) {

  //Default data

  UndeadSpawnSite::Data data();
  UndeadSpawnSite::Blob::storeData(this, @data);
  
  //Data modifications
  
  //Initializations
  
  this.Tag("isUndeadSpawnSite");
  
}