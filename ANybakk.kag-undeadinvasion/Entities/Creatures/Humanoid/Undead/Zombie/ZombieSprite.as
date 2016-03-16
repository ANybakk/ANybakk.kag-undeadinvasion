/* 
 * Zombie sprite.
 * 
 * Author: ANybakk
 */



namespace ANybakk {

  class ZombieSprite {



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
    
    
    
  }
  
}