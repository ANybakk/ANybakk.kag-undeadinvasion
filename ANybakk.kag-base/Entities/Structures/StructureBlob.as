/* 
 * Structure blob script
 * 
 * Author: ANybakk
 */

#include "Structure.as"



//Called on initialization.
void onInit(CBlob@ this) {

  //Default data
  
  Structure::Data data();
  
  Structure::Blob::storeData(this, @data);
  
  //Data modifications
  
  //Initializations
  
  this.Tag("isStructure");
  
  //Set background tile type (for TileBackground.as)
  this.set_TileType("background tile", data.oBackgroundTileType);
  
}



//Called on death.
void onDie(CBlob@ this) {

  //Check if invalid
  if(this is null) {
  
    return;
    
  }
  
  //Retrieve data
  Structure::Data@ data = Structure::Blob::retrieveData(this);
  
  //Check if placed
  if(data.iIsPlaced) {
  
    //Tag recently destroyed
    data.iWasDestroyed = true;
    
  }
  
  //Otherwise (not placed)
  else {
  
    //Tag recently removed
    data.iWasRemoved = true;
    
  }
  
}



//Called on pickup check.
bool canBePickedUp(CBlob@ this, CBlob@ byBlob) {

  return false;
  
}



//
void onSetStatic(CBlob@ this, const bool isStatic) {

  //Check if not static
  if(!isStatic) {
    
    //Finished, entity not yet static
    return;
    
  }
  
  //Retrieve data
  Structure::Data@ data = Structure::Blob::retrieveData(this);
  
  //Set recently placed
  data.iWasPlaced = true;
  
  //Set placed
  data.iIsPlaced = true;
  
  //Store orientation using segment's angle
  data.iOrientation = this.getShape().getAngleDegrees();
  
}