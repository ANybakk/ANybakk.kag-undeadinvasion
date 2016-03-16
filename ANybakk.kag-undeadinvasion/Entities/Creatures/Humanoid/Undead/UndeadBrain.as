/* 
 * Undead brain script
 * 
 * Author: ANybakk
 */

#include "Undead.as"
#include "Creature.as"

#include "PressOldKeys.as";
#include "Hitters.as";



//Called on initialization.
void onInit(CBrain@ this) {

  //Obtain blob reference
  CBlob@ blob = this.getBlob();
  
  //Retrieve data
  Undead::Data@ data = Undead::Blob::retrieveData(blob);
  
  //Set delay count variable
  data.iBrainDelayCounter = data.oBrainDelay;
  
  //Set attack time tracking variable to current time
  data.iLastAttackTime = getGameTime();
  
  //Tell script to be removed if tagged dead
  this.getCurrentScript().removeIfTag	= "dead";
  
  //Set script flag for blob proximity
  //this.getCurrentScript().runFlags |= Script::tick_blob_in_proximity;

  //Set script flag for tick not attached
  //this.getCurrentScript().runFlags |= Script::tick_not_attached;
  
  //Tell script to use players for proximity
  //this.getCurrentScript().runProximityTag = "player";
  
  //Tell script to use a proximity radius of 200.0
  //this.getCurrentScript().runProximityRadius = 200.0f; //TODO: Why 200?
  
  //Finished
  
}

//Called on every tick.
void onTick(CBrain@ this) {

  //Obtain blob reference
  CBlob@ blob = this.getBlob();
  
  //Retrieve data
  Undead::Data@ data = Undead::Blob::retrieveData(blob);
  
  //Check if delay tracker still hasn't reached 0
  if(data.iBrainDelayCounter > 0) {
  
    //Count down
    data.iBrainDelayCounter--;
  
  }
  
  //Check if delay tracker has reach zero
  if(data.iBrainDelayCounter == 0) {
  
    //Reset delay tracker
    data.iBrainDelayCounter = data.oBrainDelay;
  
    //Create a handle for a target blob object
    CBlob@ target;
    
    //Check if mode is invading mode
    if(data.iMode == Undead::Mode::MODE_INVADING) {
    
      //Create an array of blob target references
      CBlob@[] potentialTargets;
      
      //Create a handle for a blob object
      CBlob@ potentialTarget;
      
      //Keep in mind that a target has not yet been found
      bool targetFound = false;
      
      //Use the map to find nearby blobs, within detection radius
      blob.getMap().getBlobsInRadius(blob.getPosition(), data.oBrainDetectRadius, @potentialTargets);
      
      //Iterate through possible targets (stop if found)
      for(uint i = 0; i < potentialTargets.length && !targetFound; i++) {
      
        //Get a reference to the possible target's blob object
        @potentialTarget = potentialTargets[i];
        
        //Check if the target is the same blob
        if(potentialTarget is blob) {
        
          //Skip to the next one
          continue;
          
        }
        
        //Check if target is not on the same team and is tagged as creature or flesh
        if(potentialTarget.getTeamNum() != blob.getTeamNum() && (potentialTarget.hasTag("isCreature") || potentialTarget.hasTag("flesh"))) {
            
          //Store a reference to this target object
          @target = potentialTarget;
          
          //Note that a target was found
          targetFound = true;
        
        }
      
      }
      
      //Check if a target was found
      if(targetFound) {
          
        //Store target id
        data.iTargetID = potentialTarget.getNetworkID();
        
        //Set mode variable to targeting mode
        data.iMode = Undead::Mode::MODE_TARGETING;
        
        //Set has detected flag (used for animation and sound)
        data.iHasDetected = true;
        
        //Move towards target
        //blob.setKeyPressed((target.getPosition().x < blob.getPosition().x) ? key_left : key_right, true);
        Undead::Blob::pressMovementKeys(blob, target);
      
      }
      
      //Otherwise, if a target wasn't found
      else {
    
        //Create an array of blob target references
        CBlob@[] potentialSpawnSites;
      
        //Keep track of shortest distance
        f32 shortestDistance = 0.0f;

        //Retrieve a reference to any survivor spawn blobs
        getBlobsByTag("isSurvivorSpawnSite", @potentialSpawnSites);
        
        //Iterate through all survivor spawns
        for(uint i = 0; i < potentialSpawnSites.length; i++) {
          
          //Store a reference to this spawn blob object
          @potentialTarget = potentialSpawnSites[i];
          
          //Determine the distance
          f32 distance = (potentialTarget.getPosition() - blob.getPosition()).getLength();
          
          //Check if distance is shorter than any previous ones
          if(distance < shortestDistance || i == 0) {
            
            //Store a reference to this target object
            @target = potentialTarget;
            
            //Store new shortest distance
            shortestDistance = distance;
            
          }
          
        }
        
        //Check if target exists
        if (target !is null) {
        
          //Keep moving towards nearest player spawn
          //blob.setKeyPressed((target.getPosition().x < blob.getPosition().x) ? key_left : key_right, true);
          Undead::Blob::pressMovementKeys(blob, target);
          
        }
        
      }
      
    }
    
    //Check if mode is targeting mode
    else if(data.iMode == Undead::Mode::MODE_TARGETING) {
    
      //Retrieve a reference to the target blob object
      @target = getBlobByNetworkID(data.iTargetID);
      
      //Check if target is not valid
      if(target is null) {
      
        //Set mode variable to invading mode
        data.iMode = Undead::Mode::MODE_INVADING;
        
      }
      
      //Otherwise, target is valid
      else {
      
        //Create a vector
        Vec2f attackVector = Blob::getVector(blob, target);
       
        //Check if still within range, based on the brain's chasing radius
        if(Undead::Blob::isWithinChasingRange(blob, target)) {
      
          //Determine attack frequency
          f32 attackFrequency = data.oBrainAttackFrequency * getTicksASecond();
          
          //Retrieve attack time variable
          u16 attackTime = data.iLastAttackTime;
          
          //Determine if it's time to attack, by checking lapsed time against frequency
          bool isTimeToAttack = (getGameTime() - attackTime) >= attackFrequency;
          
          //Determine if target is within range
          bool isWithinMeleeRange = Creature::Blob::isWithinMeleeRange(blob, target);
          
          //Check if it's time to attack, and if target is within attack range (shape's radius)
          if(isTimeToAttack && isWithinMeleeRange) {
            
            //Normalize vector
            attackVector.Normalize();
            
            //Retrieve attack damage variable
            f32 attackDamage = data.oAttackDamage;
            
            //Initiate bite attack
            blob.server_Hit(target, target.getPosition(), attackVector, attackDamage, Hitters::bite, false);
        
            //Update attack time variable
            data.iLastAttackTime = getGameTime();
            
            //Set has attacked flag (used for animation and sound)
            data.iHasAttacked = true;
            
          }
          
          //Otherwise, if not attacking yet or if target is not within attack range
          else {
          
            //Pursue target by initiating movement through key press
            Undead::Blob::pressMovementKeys(blob, target);
            
          }
          
        }
        
        //Otherwise, target is out of range
        else {
      
          //Set mode variable to invading mode
          data.iMode = Undead::Mode::MODE_INVADING;
        
        }
      
      }
  
    }
    
  } else {
  
    //Keep any doing any current movement/actions (PressOldKeys.as)
    PressOldKeys(blob);
  
  }
  
}