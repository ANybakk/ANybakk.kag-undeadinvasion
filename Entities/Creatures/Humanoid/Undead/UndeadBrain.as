/* 
 * This script holds everything associated with the brain aspect of the Undead 
 * entity.
 *
 * The AI is fairly simple. Undead brains are either in invading mode, or 
 * targeting mode. In the first case, the undead will target the nearest 
 * survivor spawn. In the second case, the undead will chase a survivor or 
 * animal as long as it is within range. If the undead stumbles across a 
 * survivor or animal while in invading mode, it will switch to targeting mode. 
 * It will switch back to invading mode if the target is too far away.
 * 
 * NOTE:  This script relies on the variables set in "UndeadVariables.as", and 
 *        must therefore be bundled together with it, or a derived version, 
 *        within the same name-space.
 * 
 * Author: ANybakk
 */

#include "Blob.as";
#include "CreatureBlob.as";
#include "UndeadBlob.as";
#include "UndeadBrainMode.as";

#include "PressOldKeys.as";
#include "Hitters.as";



namespace UndeadInvasion {

  namespace UndeadBrain {
  
  
  
    /**
     * Initialization event function
     */
    void onInit(CBrain@ this) {

      //Obtain a reference to the blob object
      CBlob@ blob = this.getBlob();
      
      //Set delay count variable
      blob.set_u8("brain_delay", UndeadVariables::BRAIN_DELAY);
      
      //Set mode variable to invading
      blob.set_u8("brainMode", UndeadBrainMode::MODE_INVADING);
      
      //Set attack time tracking variable to current time
      blob.set_u16("lastAttackTime", getGameTime());
      
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
    
    
    
    /**
     * Tick event function
     */
    void onTick(CBrain@ this) {

      //Obtain a reference to the blob object
      CBlob@ blob = this.getBlob();
      
      //Retrieve delay tracker variable
      u8 brainDelay = blob.get_u8("brain_delay");
      
      //Check if delay tracker still hasn't reached 0
      if(brainDelay > 0) {
      
        //Count down
        brainDelay--;
      
      }
      
      //Check if delay tracker has reach zero
      if(brainDelay == 0) {
      
        //Reset delay tracker
        brainDelay = UndeadVariables::BRAIN_DELAY;
      
        //Create a handle for a target blob object
        CBlob@ target;
      
        //Retrieve mode variable
        u8 brainMode = blob.get_u8("brainMode");
        
        //Check if mode is invading mode
        if(brainMode == UndeadBrainMode::MODE_INVADING) {
        
          //Create an array of blob target references
          CBlob@[] potentialTargets;
          
          //Create a handle for a blob object
          CBlob@ potentialTarget;
          
          //Keep in mind that a target has not yet been found
          bool targetFound = false;
          
          //Use the map to find nearby blobs, within detection radius
          blob.getMap().getBlobsInRadius(blob.getPosition(), UndeadVariables::BRAIN_DETECT_RADIUS, @potentialTargets);
          
          //Iterate through possible targets (stop if found)
          for(uint i = 0; i < potentialTargets.length && !targetFound; i++) {
          
            //Get a reference to the possible target's blob object
            @potentialTarget = potentialTargets[i];
            
            //Check if the target is the same blob
            if(potentialTarget is blob) {
            
              //Skip to the next one
              continue;
              
            }
            
            //Check if target is not on the same team and is tagged with flesh
            if(potentialTarget.getTeamNum() != blob.getTeamNum() && potentialTarget.hasTag("flesh")) {
                
              //Store a reference to this target object
              @target = potentialTarget;
              
              //Note that a target was found
              targetFound = true;
            
            }
          
          }
          
          //Check if a target was found
          if(targetFound) {
              
            //Store target id
            blob.set_netid("brainTargetID", potentialTarget.getNetworkID());
            
            //Set mode variable to targeting mode
            blob.set_u8("brainMode", UndeadBrainMode::MODE_TARGETING);
            
            //Set has detected flag (used for animation and sound)
            blob.set_bool("hasDetected", true);
            
            //Move towards target
            //blob.setKeyPressed((target.getPosition().x < blob.getPosition().x) ? key_left : key_right, true);
            UndeadInvasion::UndeadBlob::pressMovementKeys(blob, target);
          
          }
          
          //Otherwise, if a target wasn't found
          else {
        
            //Create an array of blob target references
            CBlob@[] potentialSpawnSites;
          
            //Keep track of shortest distance
            f32 shortestDistance = 0.0f;

            //Retrieve a reference to any survivor spawn blobs
            //TODO: Generalize for any kind of Survivor Spawn Site, using tag
            getBlobsByName("SurvivorCamp", @potentialSpawnSites);
            
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
              UndeadInvasion::UndeadBlob::pressMovementKeys(blob, target);
              
            }
            
          }
          
        }
        
        //Check if mode is targeting mode
        else if(brainMode == UndeadBrainMode::MODE_TARGETING) {
        
          //Retrieve a reference to the target blob object
          @target = getBlobByNetworkID(blob.get_netid("brainTargetID"));
          
          //Check if target is not valid
          if(target is null) {
          
            //Set mode variable to invading mode
            blob.set_u8("brainMode", UndeadBrainMode::MODE_INVADING);
            
          }
          
          //Otherwise, target is valid
          else {
          
            //Create a vector
            Vec2f attackVector = UndeadInvasion::Blob::getVector(blob, target);
           
            //Check if still within range, based on the brain's chasing radius
            if(UndeadInvasion::UndeadBlob::isWithinChasingRange(blob, target)) {
          
              //Determine attack frequency
              u8 attackFrequency = UndeadVariables::BRAIN_ATTACK_FREQUENCY * getTicksASecond();
              
              //Retrieve attack time variable
              u16 attackTime = blob.get_u16("lastAttackTime");
              
              //Determine if it's time to attack, by checking lapsed time against frequency
              bool isTimeToAttack = (getGameTime() - attackTime) >= attackFrequency;
              
              //Determine if target is within range
              bool isWithinMeleeRange = UndeadInvasion::CreatureBlob::isWithinMeleeRange(blob, target);
              
              //Check if it's time to attack, and if target is within attack range (shape's radius)
              if(isTimeToAttack && isWithinMeleeRange) {
                
                //Normalize vector
                attackVector.Normalize();
                
                //Retrieve attack damage variable
                f32 attackDamage = UndeadVariables::ATTACK_DAMAGE;
                
                //Initiate bite attack
                blob.server_Hit(target, target.getPosition(), attackVector, attackDamage, Hitters::bite, false);
            
                //Update attack time variable
                blob.set_u16("lastAttackTime", getGameTime());
                
                //Set has attacked flag (used for animation and sound)
                blob.set_bool("hasAttacked", true);
                
              }
              
              //Otherwise, if not attacking yet or if target is not within attack range
              else {
              
                //Pursue target by initiating movement through key press
                UndeadInvasion::UndeadBlob::pressMovementKeys(blob, target);
                
              }
              
            }
            
            //Otherwise, target is out of range
            else {
          
              //Set mode variable to invading mode
              blob.set_u8("brainMode", UndeadBrainMode::MODE_INVADING);
            
            }
          
          }
      
        }
        
      } else {
      
        //Keep any doing any current movement/actions (PressOldKeys.as)
        PressOldKeys(blob);
      
      }
        
      //Save delay tracker variable
      blob.set_u8("brain_delay", brainDelay);
      
      //Finished

    }
    
    
    
  }
  
}
  