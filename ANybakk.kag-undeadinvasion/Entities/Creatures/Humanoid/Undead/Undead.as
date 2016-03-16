/* 
 * Undead
 * 
 * Author: ANybakk
 * 
 * TODO: Idea: Create player-controlled Undead entities
 * TODO: Consider custom "corpse" block on death by spikes etc., (use server_SetTile(Vec2f, Tile))
 * TODO: Consider letting undead dig through dirt if they smell flesh (lower ranges than above-ground perception)
 */

#include "Entity.as"



namespace Undead {



  const string NAME = "Undead";
  
  
  
  shared class Data {
    
    //Options
    
    int                   oTeamNumber               = -1;
    u8                    oRottingTime              = 5;                        //Time to rot.
    f32                   oAttackDamage             = 0.5f;                     //0.5 is normally half a heart (game mode attack modifier of 0.5).
    string                oAttackSound              = "/ZombieBite";            //Attack sound.
    string                oAttackAnimation          = "bite";                   //Attack animation.
    string                oJumpAnimation            = "";                       //Climbing animation.
    string                oTargetAnimation          = "run";                    //Target animation.
    string                oTargetSound              = "/ZombieGroan";           //Target sound.
    string                oInvadeAnimation          = "walk";                   //Invade animation.
    string                oDetectedOrRandomSound    = "/ZombieGroan";           //Detected or random occuring sound.
    string                oStepOnGroundSound        = "/EarthStep";             //Step on ground sound.
    string                oStepOnBlockSound         = "/StoneStep";             //Step on block sound.
    string                oIdleAnimation            = "idle";                   //Idle animation.
    f32                   oCollateralAttackDamage   = 0.1f;                     //Collateral (tile) attack damage.
    f32                   oCollateralAttackFrequency = 1.0f;                    //Collateral (tile) attack frequency, in seconds.
    u8                    oDropCoinAmount           = 2;                        //Number of coins to drop on death.
    u8                    oBrainDelay               = 5;                        //A delay of the brain, in number of ticks. TODO: Define in terms of seconds (float).
    f32                   oBrainDetectRadius        = 32.0f;                    //Detection radius.
    f32                   oBrainChaseRadius         = 48.0f;                    //Chasing radius of 48.0. Should be longer than detection radius.
    f32                   oBrainAttackFrequency     = 2;                        //Attack frequency, in seconds.
    Vec2f                 oMovementFactorWater      (0.5f, 1.0f);               //Factor for movement in water.
    Vec2f                 oMovementFactorSlowdown   (2.0f, 0.0f);               //Factor for slowing down.
    f32                   oMovementMaxVelocity      = 0.5f;                     //Maximum velocity.
    Vec2f                 oMovementWalkAcceleration (3.0f, 0.0f);               //Walking acceleration.
    Vec2f                 oMovementRunAcceleration  (5.0f, 0.0f);               //Running acceleration.
    Vec2f                 oMovementJumpAcceleration (0.0f, -2.4f);              //Jumping acceleration.
    
    //EventData (do-once)
    
    //EventData (do-while)
    
    //Internals
    
    u32                   iTargetID                 = 0;
    u8                    iMode                     = Undead::Mode::MODE_INVADING;
    bool                  iHasAttacked              = false;
    bool                  iHasJumped                = false;
    bool                  iHasDetected              = false;
    bool                  iCollidedWithUndeadInFront = false;
    u32                   iLastAttackTime           = 0;
    u32                   iLastCollateralAttackTime = 0;
    u8                    iBrainDelayCounter        = 0;
    
  }
  
  
  
  shared class SomeType {
    
    int           someVariable;                                                 //Some variable
  
  }
  
  
  
  namespace Mode {


    /**
     * Enumeration for a zombie's mode
     */
    enum Mode {
      MODE_INVADING = 0,
      MODE_TARGETING
    }

  }
  
  
  
  namespace Blob {
  
  
  
    /**
     * Stores a data object
     * 
     * @param   this    a blob pointer.
     * @param   data     a data pointer.
     */
    void storeData(CBlob@ this, Data@ data = null) {

      if(data is null) {
      
        @data = Data();
        
      }
      
      this.set(NAME + "::Data", @data);
      
    }
    
    
    
    /**
     * Retrieves a data object.
     * 
     * @param   this    a blob pointer.
     * @return  data     a pointer to the data (null if none was found).
     */
    Data@ retrieveData(CBlob@ this) {
    
      Data@ data;
      
      this.get(NAME + "::Data", @data);
      
      return data;
      
    }
    
    
    
    /**
     * Checks if a target is within chasing range.
     * 
     * @param   this            a blob reference.
     * @param   target          the target blob.
     */
    bool isWithinChasingRange(CBlob@ this, CBlob@ target) {
    
      //Retrieve data
      Undead::Data@ data = Undead::Blob::retrieveData(this);
      
      //Finished, return true if distance is within the combined radius
      return Entity::Blob::getDistance(this, target) <= data.oBrainChaseRadius;
      
    }
    
    
    
    /**
     * Checks if a target is within detection range.
     * 
     * @param   this            a blob reference.
     * @param   target          the target blob.
     */
    bool isWithinDetectionRange(CBlob@ this, CBlob@ target) {
    
      //Retrieve data
      Undead::Data@ data = Undead::Blob::retrieveData(this);
      
      //Finished, return true if distance is within the combined radius
      return Entity::Blob::getDistance(this, target) <= data.oBrainDetectRadius;
      
    }
    
    
    
    /**
     * Presses the correct movement keys to reach a target blob.
     * 
     * @param   this            a blob reference.
     * @param   target          the target blob.
     */
    void pressMovementKeys(CBlob@ this, CBlob@ target) {
    
      //Obtain this blob's position
      Vec2f position = this.getPosition();
      
      Vec2f targetPosition = target.getPosition();
      
      //Check if on ground or in water, and horizontal position is the same or target is within range
      if((this.isOnGround() || this.isInWater()) && (targetPosition.x == position.x || isWithinChasingRange(this, target))) {
      
        //Check if target is above
        if(targetPosition.y < position.y) {
        
          //Press up key
          this.setKeyPressed(key_up, true);
          
        }
        
        //Otherwise, check if target is below
        else if(targetPosition.y > position.y) {
        
          //Press down key
          this.setKeyPressed(key_down, true);
          
        }
        
      }
      
      //Check if target is to the left
      if(targetPosition.x < position.x) {
        
        //Press left key
        this.setKeyPressed(key_left, true);
        
      }
      
      //Otherwise, check if target is to the right
      else if(targetPosition.x > position.x) {
        
        //Press right key
        this.setKeyPressed(key_right, true);
        
      }
      
      //Finished
      return;
      
    }
    
    
    
  }
  
  
  
  namespace Sprite {
  }
  
  
  
  namespace Shape {
  }
  
  
  
  namespace Movement {
  }
  
  
  
  namespace Brain {
  }
  
  
  
  namespace Attachment {
  }
  
  
  
  namespace Inventory {
  }
  
  
}