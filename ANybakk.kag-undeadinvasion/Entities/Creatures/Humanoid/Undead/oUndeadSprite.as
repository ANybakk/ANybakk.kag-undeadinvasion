/* 
 * Undead sprite.
 * 
 * Author: ANybakk
 */

#include "UndeadVariables.as"
#include "UndeadBrainMode.as"



namespace ANybakk {

  class UndeadSprite {
  
  
  
    UndeadVariables       mVariables;
    
    
    
    UndeadSprite(UndeadVariables pVariables) {
    
      mVariables = pVariables;
      
    }
  
  
  
    /**
     * Initialization event function
     */
    void onInit(CSprite@ this) {

      //Obtain a reference to the blob object
      CBlob@ blob = this.getBlob();
      
      //Request a reload of the sprites
      this.ReloadSprites(blob.getTeamNum(), 0);

      //Finished
      
    }



    /**
     * Tick event function
     */
    void onTick(CSprite@ this) {
    
      //Obtain a reference to the blob object
      CBlob@ blob = this.getBlob();
      
      //Obtain a reference to the map object
      CMap@ map = blob.getMap();
      
      //Check if has attacked flag is set and biting animation is not yet active
      if(blob.get_bool("hasAttacked")) {
      
        //Play biting sound
        this.PlaySound("/ZombieBite");
        
        //Initiate biting animation
        this.SetAnimation("bite");
        
        //Remove flag
        blob.set_bool("hasAttacked", false);
        
      }
      
      else if(blob.get_bool("hasJumped")) {
        
        //Initiate biting animation
        //this.SetAnimation("climb");
        
        //Remove flag
        blob.set_bool("hasJumped", false);
        
      }
      
      //Otherwise, check if brain is in targeting mode
      else if(blob.get_u8("brainMode") == UndeadBrainMode::MODE_TARGETING) {
        
        //Check if running animation is not active
        if(!this.isAnimation("run")) {
        
          //Play groaning sound
          this.PlaySound( "/ZombieGroan" );
          
          //Initiate running animation
          this.SetAnimation("run");
          
        }
        
      }
      
      //Check if brain is in invading mode
      else if(blob.get_u8("brainMode") == UndeadBrainMode::MODE_INVADING) {
        
        //Check if walking animation is not active
        if(!this.isAnimation("walk")) {
        
          //Initiate walking animation
          this.SetAnimation("walk");
          
        }
        
      }
      
      //Otherwise
      else {
      
        //Check if has detected flag is set, or once in 200 times
        if(blob.get_bool("hasDetected") || XORRandom(200)==0) {
          
          //Play groaning sound
          this.PlaySound( "/ZombieGroan" );
          
        }
        
        //Check if currently on the ground and moving either left or right
        //COMMENT: Instead of checking for key presses, perhaps it would be possible to interact with the CMovement object, but it's undocumented
        if(blob.isOnGround() && (blob.isKeyPressed(key_left) || blob.isKeyPressed(key_right)) ) {
        
          //Every 9th frame (network id dependant offset)
          if((blob.getNetworkID() + getGameTime()) % 9 == 0) {
            
            //Determine sound volume based on current horizontal velocity (maximum 1.0)
            f32 soundVolume = Maths::Min( 0.1f + Maths::Abs(blob.getVelocity().x)*0.1f, 1.0f );
            
            //Retrieve a tile object for the tile below (vertical distance is the blob's radius + half a tile)
            TileType tile = map.getTile( blob.getPosition() + Vec2f( 0.0f, blob.getRadius() + map.tilesize/2 )).type;
            
            //Check if tile is considered the ground
            if(map.isTileGroundStuff(tile)) {
            
              //Play earth step sound
              this.PlaySound("/EarthStep", soundVolume, 0.75f );
              
            }
            
            //Otherwise, when tile is not the ground
            else {
            
              //Play stone step sound
              this.PlaySound("/StoneStep", soundVolume, 0.75f );
              
            }
            
          }
            
        }

        //Check if idle animation is not active
        if(!this.isAnimation("idle")) {
        
          //Initiate idle animation
          this.SetAnimation("idle");
          
        }
      
      }

      //Finished
      
    }



    /**
     * Rendering event function
     */
    void onRender(CSprite@ this) {
    
      //Check if debug mode
      if(g_debug > 0) {
      
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
        CBlob@ target = getBlobByNetworkID(blob.get_netid("brainTargetID"));
        
        //Check if target is valid and still in targeting mode
        if(target !is null && blob.get_u8("brainMode") == UndeadBrainMode::MODE_TARGETING) {
        
          //Retrieve screen position for target
          Vec2f targetScreenPosition = getDriver().getScreenPosFromWorldPos(target.getPosition());
          
          //Draw an arrow
          GUI::DrawArrow2D( thisScreenPosition, targetScreenPosition, SColor(0xffff0000) );
          
        }
        
      }
      
      //Finished
      return;
      
    }
    
    
    
  }
  
}