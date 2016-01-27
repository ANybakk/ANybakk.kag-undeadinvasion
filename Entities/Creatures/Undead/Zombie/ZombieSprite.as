/*
 * UndeadInvasion Zombie sprite
 * 
 * This scripts handles anything to do with sprites, gibs and sounds.
 * 
 * Author: ANybakk
 * Based on previous work by: Eanmig
 */
 
#include "ZombieBrainMode.as";



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
  
  //Check if has attacked flag is set and biting animation is not yet active
  if(blob.get_bool("hasAttacked")) {
  
    //Play biting sound
    this.PlaySound("/ZombieBite");
    
    //Initiate biting animation
    this.SetAnimation("bite");
    
    //Remove flag
    blob.set_bool("hasAttacked", false);
    
  }
  
  //Check if brain is in targeting mode
  else if(blob.get_u8("brainMode") == ZombieBrainMode::MODE_TARGETING) {
    
    //Check if running animation is not active
    if(!this.isAnimation("run")) {
    
      //Play groaning sound
      this.PlaySound( "/ZombieGroan" );
      
      //Initiate running animation
      this.SetAnimation("run");
      
    }
    
  }
  
  //Check if brain is in invading mode
  else if(blob.get_u8("brainMode") == ZombieBrainMode::MODE_INVADING) {
    
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
        
        //Retrieve a tile object for the tile below (vertical distance 4.0)
        TileType tile = blob.getMap().getTile( blob.getPosition() + Vec2f( 0.0f, blob.getRadius() + 4.0f )).type;
        
        //Check if tile is considered the ground
        if(blob.getMap().isTileGroundStuff(tile)) {
        
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

  //Finished

}



/**
 * Gib event function
 */
void onGib(CSprite@ this) {

  //Check if kids safe mode is active
  if (g_kidssafe) {
  
    return;
    
  }

  //Obtain a reference to the blob object
  CBlob@ blob = this.getBlob();
  
  //Retrieve position
  Vec2f pos = blob.getPosition();
  
  //Retrieve velocity
  Vec2f vel = blob.getVelocity();
  
  //Correct vertical velocity by 3.0
  vel.y -= 3.0f;
  
  //Calculate health to be current health (minimum 2.0) plus 1.0
  f32 hp = Maths::Min(Maths::Abs(blob.getHealth()), 2.0f) + 1.0;
  
  //Retrieve the team number
  const u8 team = blob.getTeamNum();
  
  //Create body gib
  CParticle@ Body     = makeGibParticle( "ZombieGibs.png", pos, vel + getRandomVelocity( 90, hp , 80 ),       1, 0, Vec2f (8,8), 2.0f, 20, "/BodyGibFall", team );
  
  //Create first arm gib
  CParticle@ Arm1     = makeGibParticle( "ZombieGibs.png", pos, vel + getRandomVelocity( 90, hp - 0.2 , 80 ), 1, 1, Vec2f (8,8), 2.0f, 20, "/BodyGibFall", team );
  
  //Create second arm gib
  CParticle@ Arm2     = makeGibParticle( "ZombieGibs.png", pos, vel + getRandomVelocity( 90, hp - 0.2 , 80 ), 1, 2, Vec2f (8,8), 2.0f, 20, "/BodyGibFall", team );
  
  //Finished
  
}