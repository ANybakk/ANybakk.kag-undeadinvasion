/* 
 * Undead sprite script
 * 
 * Author: ANybakk
 */

#include "Undead.as"



//Called on initialization.
void onInit(CSprite@ this) {

  //Obtain blob reference
  CBlob@ blob = this.getBlob();
  
  //Retrieve data
  //Undead::Data@ data = Undead::Blob::retrieveData(blob);
  
  //Request a reload of the sprites
  this.ReloadSprites(blob.getTeamNum(), 0);
  
}

//
void onRender(CSprite@ this) {

  //Check if debug mode
  if(g_debug > 0) {

    //Obtain blob reference
    CBlob@ blob = this.getBlob();
    
    //Retrieve data
    Undead::Data@ data = Undead::Blob::retrieveData(blob);
  
    //Set menu font
    GUI::SetFont("menu");

    //Obtain a reference to the blob object
    CBlob@ blob = this.getBlob();
    
    //Retrieve screen position for this blob
    //COMMENT: Alternatively use a saved position at the time of collision
    Vec2f thisScreenPosition = getDriver().getScreenPosFromWorldPos(blob.getPosition());
    
    //Retrieve screen position for collision
    Vec2f collidedWithScreenPosition = getDriver().getScreenPosFromWorldPos(blob.get_Vec2f("collidedWithPosition"));
    
    //Draw an asterix
    GUI::DrawText("*", collidedWithScreenPosition, SColor(0xffff8000));
    
    //Retrieve a reference to current targeted blob
    CBlob@ target = getBlobByNetworkID(data.iTargetID);
    
    //Check if target is valid and still in targeting mode
    if(target !is null && data.iMode == Undead::Mode::MODE_TARGETING) {
    
      //Retrieve screen position for target
      Vec2f targetScreenPosition = getDriver().getScreenPosFromWorldPos(target.getPosition());
      
      //Draw an arrow
      GUI::DrawArrow2D( thisScreenPosition, targetScreenPosition, SColor(0xffff0000) );
      
    }
    
  }
  
}

//Called on every tick.
void onTick(CSprite@ this) {

  //Obtain blob reference
  CBlob@ blob = this.getBlob();
  
  //Retrieve data
  Undead::Data@ data = Undead::Blob::retrieveData(blob);
  
  //Obtain a reference to the map object
  CMap@ map = blob.getMap();
  
  //Check if has attacked flag is set
  if(data.iHasAttacked) {
  
    //Check if sound enabled
    if(data.oAttackSound != "") {
    
      //Play sound
      this.PlaySound(data.oAttackSound);
      
    }
    
    if(data.oAttackAnimation != "") {
    
      //Initiate biting animation
      this.SetAnimation(data.oAttackAnimation);
      
    }
    
    //Unset
    data.iHasAttacked = false;
    
  }
  
  else if(data.iHasJumped) {
    
    if(data.oJumpAnimation != "") {
    
      //Initiate biting animation
      this.SetAnimation(data.oJumpAnimation);
      
    }
    
    //Unset
    data.iHasJumped = false;
    
  }
  
  //Otherwise, check if targeting mode
  else if(data.iMode == Undead::Mode::MODE_TARGETING) {
    
    //Check if running animation is not active
    if(data.oTargetAnimation != "" && !this.isAnimation(data.oTargetAnimation)) {
    
      if(data.oTargetSound != "") {
      
        //Play groaning sound
        this.PlaySound(data.oTargetSound);
        
      }
      
      //Initiate running animation
      this.SetAnimation(data.oTargetAnimation);
      
    }
    
  }
  
  //Check if brain is in invading mode
  else if(data.iMode == Undead::Mode::MODE_INVADING) {
    
    //Check if walking animation is not active
    if(data.oInvadeAnimation != "" && !this.isAnimation(data.oInvadeAnimation)) {
    
      //Initiate walking animation
      this.SetAnimation(data.oInvadeAnimation);
      
    }
    
  }
  
  //Otherwise
  else {
  
    //Check if has detected flag is set, or once in 200 times
    if(data.iHasDetected || XORRandom(200)==0) {
      
      if(data.oDetectedOrRandomSound != "") {
      
        //Play groaning sound
        this.PlaySound(data.oDetectedOrRandomSound);
        
      }
      
    }
    
    //Check if any step sound is set
    if(data.oStepOnGroundSound != "" || data.oStepOnBlockSound != "") {
    
      //Check if currently on the ground and moving either left or right
      //COMMENT: Instead of checking for key presses, perhaps it would be possible to interact with the CMovement object, but it's undocumented
      if(blob.isOnGround() && (blob.isKeyPressed(key_left) || blob.isKeyPressed(key_right)) ) {
      
        //Every 9th frame (network id dependant offset)
        if((blob.getNetworkID() + getGameTime()) % 9 == 0) {
          
          //Determine sound volume based on current horizontal velocity (maximum 1.0)
          f32 soundVolume = Maths::Min( 0.1f + Maths::Abs(blob.getVelocity().x)*0.1f, 1.0f );
          
          //Retrieve a tile object for the tile below (vertical distance is the blob's radius + half a tile)
          TileType tile = map.getTile( blob.getPosition() + Vec2f( 0.0f, blob.getRadius() + map.tilesize/2 )).type;
          
          //Check if tile is considered the ground and sound enabled
          if(map.isTileGroundStuff(tile) && data.oStepOnGroundSound != "") {
          
            //Play earth step sound
            this.PlaySound(data.oStepOnGroundSound, soundVolume, 0.75f );
            
          }
          
          //Otherwise, check if block step sound enabled
          else if(data.oStepOnBlockSound != ""){
          
            //Play stone step sound
            this.PlaySound(data.oStepOnBlockSound, soundVolume, 0.75f );
            
          }
          
        }
          
      }
      
    }

    //Check if idle animation is not active
    if(data.oIdleAnimation != "" && !this.isAnimation(data.oIdleAnimation)) {
    
      //Initiate idle animation
      this.SetAnimation(data.oIdleAnimation);
      
    }
  
  }
  
}