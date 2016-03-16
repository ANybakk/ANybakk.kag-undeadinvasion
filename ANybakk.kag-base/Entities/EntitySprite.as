/* 
 * Entity sprite script
 * 
 * Author: ANybakk
 */

#include "Entity.as"



void onInit(CSprite@ this) {

  //Obtain blob reference
  CBlob@ blob = this.getBlob();
  
  //Retrieve data and initialize
  Entity::Data@ data = Entity::Blob::retrieveData(blob);
  data.iSpriteSize.Set(this.getFrameWidth(), this.getFrameHeight());
  
  //Set event flags
  data.eSpriteWasInitialized.iTime = data.iGameTime;
  data.eSpriteIsInitialized.iTime = data.iGameTime;
  
  //Set default mode/animation
  Entity::Sprite::setMode(this, "default");
  
  //Set default state/frame
  Entity::Sprite::setState(this, 0);
  
}



void onTick(CSprite@ this) {

  //Obtain blob reference
  CBlob@ blob = this.getBlob();
  
  //Check if invalid blob reference
  if(blob is null) {
  
    return;
    
  }
  
  //Retrieve data
  Entity::Data@ data = Entity::Blob::retrieveData(blob);
  
  //Check if not automatically animated and animated according to health
  if(!data.oSpriteAutoAnimated && data.oSpriteAnimateByHealth) {
  
    //Set state/frame based on health
    Entity::Sprite::setStateAccordingToHealth(this);
    
  }
  
}



//
void onGib(CSprite@ this) {

  //Obtain blob reference
  CBlob@ blob = this.getBlob();
  
  //Retrieve data
  Entity::Data@ data = Entity::Blob::retrieveData(blob);
  
  //Set event flag
  data.eSpriteWasGibbed.iTime = data.iGameTime;
  
}