/* 
 * Structure sprite script
 * 
 * Author: ANybakk
 */

#include "Structure.as"



//Called on every tick.
void onTick(CSprite@ this) {

  //Obtain blob reference
  CBlob@ blob = this.getBlob();
  
  //Check if invalid blob reference
  if(blob is null) {
  
    return;
    
  }
  
  //Retrieve data
  Structure::Data@ data = Structure::Blob::retrieveData(blob);
  
  //Check if tagged recently placed
  if(data.iWasPlaced) {
  
    //Play a sound
    this.PlaySound(data.oPlacementSound);
    
    //Unset
    data.iWasPlaced = false;
    
  }
  
}