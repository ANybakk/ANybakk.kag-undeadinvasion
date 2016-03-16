/* 
 * Building blob script
 * 
 * Author: ANybakk
 */

#include "Building.as"
#include "Entity.as"


//Called on initialization.
void onInit(CBlob@ this) {

  //Default data
  
  Building::Data data();
  Building::Blob::storeData(this, @data);
  
  //Entity data modifications
  
  Entity::Data@ entityData = Entity::Blob::retrieveData(this);
  entityData.oSpriteAutoAnimated = false;
  
  //Initializations
  
  this.Tag("isBuilding");
  
  //Set background tiles (for ???.as)
  this.set_TileType("background tile", data.oBackWallType);
  
}



//Called on every tick.
void onTick(CBlob@ this) {
  
  //Retrieve data
  Building::Data@ data = Building::Blob::retrieveData(this);

  //Check if window flag is false
  if(!data.oHasWindow) {
  
    //Find window position (created by DefaultBuilding.as)
    Vec2f windowPosition = this.getPosition() - Vec2f(0, 4);
    
    //Repair window
    this.getMap().server_SetTile(windowPosition, data.oBackWallType);
    
  }
  
}