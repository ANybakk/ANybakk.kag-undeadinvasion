/*
 * UndeadInvasion Zombie sprite
 * 
 * This scripts handles anything to do with sprites, gibs and sounds.
 * 
 * Author: ANybakk
 * Based on previous work by: Eanmig
 */



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
  
  //Check if revival animation is already in progress
  if(this.isAnimation("revive") && !this.isAnimationEnded()) {
  
    return;
    
  }
  
  //Check if biting animation is already in progress
	if(this.isAnimation("bite") && !this.isAnimationEnded()) {
  
    return;
    
  }
  
  //Check if zombie has any health left
  if(blob.getHealth() > 0.0) {
  
    //Retrieve horizontal velocity
    f32 x = blob.getVelocity().x;
    
    //Check if death animation is already in progress or finished
    if(this.isAnimation("dead")) {
    
      //Initiate revival animation
      //this.SetAnimation("revive");
      
    }
    
    /*
    //Check if climb variable is set higher than 1
    else if(blob.get_s32("climb") > 1 ) {
    
      //Check if climbing animation is not active
      if(!this.isAnimation("climb")) {
      
        //Initiate climbing animation
        this.SetAnimation("climb");
      }
      
    }
    */
    
    //Check if blob object has "biting" tag and biting animation is not active
    else if(blob.hasTag("biting") && !this.isAnimation("bite")) {
    
      //Play biting sound
      this.PlaySound("/ZombieBite");
      
      //Initiate biting animation
      this.SetAnimation("bite");
      
      return;
      
    }
    
    //Check if horizontal velocity surpasses 0.1
    else if(Maths::Abs(x) > 0.1f) {
    
      //Check if walking animation is not active
      if(!this.isAnimation("walk")) {
      
        //Initiate walking animation
        this.SetAnimation("walk");
        
      }
      
    }
    
    
    //Otherwise
    else {
    
      //Once in 200 times
      if(XORRandom(200)==0) {
        
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
  
  }
  
  //Otherwise, if zombie has no health left
  else {
  
    //Check if death animation is not active
    if(!this.isAnimation("dead")) {
    
      //Initiate death animation
      this.SetAnimation("dead");
      
      //Play death sound
      this.PlaySound( "/ZombieDie" );
      
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
  
  //Create shield gib
  //CParticle@ Shield   = makeGibParticle( "ZombieGibs.png", pos, vel + getRandomVelocity( 90, hp , 80 ),       1, 3, Vec2f (8,8), 2.0f, 0, "/BodyGibFall", team );
  
  //Create sword gib
  //CParticle@ Sword    = makeGibParticle( "ZombieGibs.png", pos, vel + getRandomVelocity( 90, hp + 1 , 80 ),   1, 4, Vec2f (8,8), 2.0f, 0, "/BodyGibFall", team );


  //Finished
  
}