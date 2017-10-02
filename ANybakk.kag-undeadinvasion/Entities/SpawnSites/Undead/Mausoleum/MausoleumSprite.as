
#include "MausoleumSpriteMode.as";
#include "MausoleumVariables.as";



/**
 * Initialization event function
 */
void onInit(CSprite@ this) {

  //Get a reference to the blob object
  CBlob@ blob = this.getBlob();
  
  //Set besieged time variable
  blob.set_u8("spriteMode", MausoleumVariables::SPRITE_MODE_DEFAULT);
  
  //Set default animation sequence
  this.animation.frame = MausoleumVariables::SPRITE_MODE_DEFAULT;
  
  //Set the background tiles to be stone back wall
  blob.set_TileType("background tile", CMap::tile_castle_back);
  
  //Finished
  return;
  
}



/**
 * Rendering event function
 */
void onRender(CSprite@ this) {

  //Get a reference to the blob object
  CBlob@ blob = this.getBlob();
  
  //Retrieve current mode
  u8 currentMode = blob.get_u8("spriteMode");
  
  //Check if mode is closed
  if(currentMode == MausoleumSpriteMode::MODE_CLOSED) {
    
    //Set closed animation sequence
    this.animation.frame = MausoleumSpriteMode::MODE_CLOSED;
    
  }
  
  //Otherwise, check if mode is opened
  if(currentMode == MausoleumSpriteMode::MODE_OPENED) {
  
    //Retrieve initial health
    f32 initialHealth = blob.getInitialHealth();
    
    //Retrieve current health
    f32 currentHealth = blob.getHealth();
    
    //Check if health is at least 2/3 of initial health
    if(currentHealth >= initialHealth*2/3) {
    
      //Set opened animation sequence, position 0
      this.animation.frame = MausoleumSpriteMode::MODE_OPENED;
      
    }
    
    //Otherwise, check if health is at least 1/3 of initial health
    else if(currentHealth >= initialHealth*1/3) {
    
      //Set opened animation sequence, position 1
      this.animation.frame = MausoleumSpriteMode::MODE_OPENED + 1;
      
    }
    
    //Otherwise
    else {
    
      //Set opened animation sequence, position 2
      this.animation.frame = MausoleumSpriteMode::MODE_OPENED + 2;
      
    }
    
    
  }
  
  //Finished
  return;
  
}