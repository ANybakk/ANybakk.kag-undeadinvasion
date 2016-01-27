/*
 * UndeadInvasion Zombie brain
 * 
 * This script handles anything related to the AI itself. The AI is fairly 
 * simple. Zombies' brains are either in invading mode, or targeting mode. In 
 * the first case, the zombie will target the nearest survivor spawn. In the 
 * second case, the zombie will chase a survivor or animal as long as it is 
 * within range. If the zombie stumbles across a survivor or animal while in 
 * invading mode, it will switch to targeting mode. It will switch back to 
 * invading mode if the target is too far away.
 * 
 * Author: ANybakk
 *
 * TODO:  Turn into a more general UndeadBrain
 * TODO:  Give zombies the ability to change target in BRAINMODE_TARGETING mode, 
 *        if another survivor/animal is closer
 * TODO:  Allow zombies to eat meaty food items they may find (steak, burger, 
 *        fish)
 */

#define SERVER_ONLY

#include "ZombieVariables.as";
#include "ZombieBrainMode.as";

#include "PressOldKeys.as";
#include "Hitters.as";



/**
 * Initialization event function
 */
void onInit(CBrain@ this) {

  //Obtain a reference to the blob object
  CBlob@ blob = this.getBlob();
  
  //Set delay count variable
  blob.set_u8("brain_delay", ZombieVariables::BRAIN_DELAY);
  
  //Set mode variable to invading
  blob.set_u8("brainMode", ZombieBrainMode::MODE_INVADING);
  
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
    brainDelay = ZombieVariables::BRAIN_DELAY;
  
    //Create a handle for a target blob object
    CBlob@ target;
  
    //Retrieve mode variable
    u8 brainMode = blob.get_u8("brainMode");
    
    //Check if mode is invading mode
    if(brainMode == ZombieBrainMode::MODE_INVADING) {
    
      //Create an array of blob target references
      CBlob@[] potentialTargets;
      
      //Create a handle for a blob object
      CBlob@ potentialTarget;
      
      //Keep in mind that a target has not yet been found
      bool targetFound = false;
      
      //Use the map to find nearby blobs, within detection radius
      blob.getMap().getBlobsInRadius(blob.getPosition(), ZombieVariables::BRAIN_DETECT_RADIUS, @potentialTargets);
      
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
        blob.set_u8("brainMode", ZombieBrainMode::MODE_TARGETING);
        
        //Set has detected flag (used for animation and sound)
        blob.set_bool("hasDetected", true);
        
        //Move towards target
        blob.setKeyPressed((target.getPosition().x < blob.getPosition().x) ? key_left : key_right, true);
      
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
          blob.setKeyPressed((target.getPosition().x < blob.getPosition().x) ? key_left : key_right, true);
          
        }
        
      }
      
    }
    
    //Check if mode is targeting mode
    else if(brainMode == ZombieBrainMode::MODE_TARGETING) {
    
      //Retrieve a reference to the target blob object
      @target = getBlobByNetworkID(blob.get_netid("brainTargetID"));
      
      //Check if target is valid
      if(target !is null) {
      
        //Create a vector
        Vec2f attackVector = target.getPosition()-blob.getPosition();
       
        //Check if still within range, based on the brain's chasing radius
        if(attackVector.getLength() <= ZombieVariables::BRAIN_CHASE_RADIUS) {
      
          //Determine attack frequency
          u8 attackFrequency = ZombieVariables::BRAIN_ATTACK_FREQUENCY * getTicksASecond();
          
          //Retrieve attack time variable
          u16 attackTime = blob.get_u16("lastAttackTime");
          
          //Check if it's time to attack, and if target is within attack range (shape's radius)
          if((getGameTime()-attackTime) >= attackFrequency && attackVector.getLength() <= blob.getRadius()) {
            
            //Normalize vector
            attackVector.Normalize();
            
            //Create an array of hit info object handles
            HitInfo@[] hitInfos;
            
            //Retrieve the map
            CMap@ map = getMap();
            
            //Keep in mind if attack was performed
            bool hasAttacked = false;
            
            //If hit info references could be obtained for an arc
            //TODO: This call returns nothing
            if (map.getHitInfosFromArc( blob.getPosition()-Vec2f(2,0).RotateBy(-attackVector.Angle()),-attackVector.Angle(),90,blob.getRadius() + 6.0f, blob, @hitInfos )) {
            
              //Create a handle for a blob object
              CBlob@ nearbyBlob;
            
              //Iterate through all hit info objects (closest first)
              for(uint i = 0; i < hitInfos.length; i++) {
              
                //Store blob reference
                @nearbyBlob = hitInfos[i].blob;
                
                //Check if blob is the target
                if(nearbyBlob is target) {
                
                  //Retrieve attack damage variable
                  f32 attackDamage = blob.get_f32("brain_attack_damage");
                  
                  //Initiate bite attack
                  blob.server_Hit(target, target.getPosition(), attackVector, attackDamage, Hitters::bite, false);
              
                  //Update attack time variable
                  blob.set_u16("lastAttackTime", getGameTime());
                  
                  //Set has attacked flag (used for animation and sound)
                  blob.set_bool("hasAttacked", true);
                  
                  //Remember that target has been hit
                  hasAttacked = true;
                  
                  //Exit loop
                  break;
                  
                }
                
              }
            
            }
            
            //Check if attack was not performed
            if(!hasAttacked) {
            
              //Pursue target by initiating movement through key press
              blob.setKeyPressed((target.getPosition().x < blob.getPosition().x) ? key_left : key_right, true);
              
            }
          
          }
          
          //Otherwise, if not attacking yet or if target is not within attack range
          else {
          
            //Pursue target by initiating movement through key press
            blob.setKeyPressed((target.getPosition().x < blob.getPosition().x) ? key_left : key_right, true);
            
          }
          
        }
        
        //Otherwise, target is out of range
        else {
      
          //Set mode variable to invading mode
          blob.set_u8("brainMode", ZombieBrainMode::MODE_INVADING);
        
        }
      
      }
      
      //Otherwise, target is not valid
      else {
      
        //Set mode variable to invading mode
        blob.set_u8("brainMode", ZombieBrainMode::MODE_INVADING);
        
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