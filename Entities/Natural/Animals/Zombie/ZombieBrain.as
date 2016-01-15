/*
 * UndeadInvasion Zombie brain
 * 
 * Author: ANybakk
 *
 * TODO: Turn into a more general UndeadBrain
 * TODO: Give zombies the ability to change target in BRAINMODE_TARGETING mode, if another survivor is closer
 * TODO: Allow zombies to eat meaty food items they may find (steak, burger, fish)
 */

#define SERVER_ONLY

#include "ZombieBrainMode.as";
#include "Hitters.as";



//Define a delay of 5 frames
const u8 brain_delay = 5; //TODO: Define in terms of seconds (float)

//Define a target radius of 32.0
const f32 brain_target_radius = 32.0f;

//Define an attack frequency of 2 seconds
const u8 brain_attack_frequency = 2;



/**
 * Initialization event function
 */
void onInit(CBrain@ this) {

  //Obtain a reference to the blob object
  CBlob@ blob = this.getBlob();
  
  //Set delay variable
  blob.set_u8("brain_delay", brain_delay);
  
  //Set mode variable to invading
  blob.set_u8("brain_mode", BRAINMODE_INVADING);
  
  //Set targeting radius variable
  blob.set_u8("brain_target_radius", brain_target_radius);
  
  //Set attack frequency variable
  blob.set_u8("brain_attack_frequency", brain_attack_frequency*getTicksASecond());
  
  //Set attack time tracking variable to current time
  blob.set_u16("brain_attack_time", getGameTime());
  
  //Tell script to be removed if tagged dead
  this.getCurrentScript().removeIfTag	= "dead";
  
  //Set script flag for blob proximity
  this.getCurrentScript().runFlags |= Script::tick_blob_in_proximity;

  //Set script flag for tick not attached
  this.getCurrentScript().runFlags |= Script::tick_not_attached;
  
  //Tell script to use players for proximity
  this.getCurrentScript().runProximityTag = "player";
  
  //Tell script to use a proximity radius of 200.0
  this.getCurrentScript().runProximityRadius = 200.0f; //TODO: Why 200?
  
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
    brainDelay = brain_delay;
  
    //Create a handle for a target blob object
    CBlob@ target;
  
    //Retrieve mode variable
    u8 brainMode = blob.get_u8("brain_mode");
    
    //Check mode
    switch(brainMode) {
    
      case BRAINMODE_INVADING:
      
        //Create an array of blob target references
        CBlob@[] potentialTargets;
        
        //Create a handle for a blob object
        CBlob@ potentialTarget
        
        //Keep in mind that a target has not yet been found
        bool targetFound = false;
        
        //Use the map to find nearby blobs
        blob.getMap().getBlobsInRadius(blob.getPosition(), blob.get_f32("brain_target_radius"), @potentialTargets);
        
        //Iterate through possible targets
        for(uint i = 0; i < potentialTargets.length; i++) {
        
          //Get a reference to the possible target's blob object
          potentialTarget = potentialTargets[i];
          
          //Check if the target is the same blob
          if(potentialTarget is blob) {
          
            //Skip to the next one
            continue;
            
          }
          
          //Check if target is not on the same team and is tagged with flesh
          if(potentialTarget.getTeamNum() != blob.getTeamNum() && potentialTarget.hasTag("flesh")) {
          
            //Set mode variable to targeting mode
            blob.set_u8("brain_mode", BRAINMODE_TARGETING);
            
            //Store target id
            blob.set_netid("brain_target_id", potentialTarget.getNetworkID());
            
            //Note that a target was found
            targetFound = true;
            
            //Abort looking for targets
            break;
          
          }
        
        }
        
        //Recall if a target wasn't found
        if(!targetFound) {
          
          //Keep track of shortest distance
          f32 shortestDistance = 0.0f;

          //Retrieve a reference to any survivor spawn blobs
          getBlobsByTag("survivor_spawn", @potentialTargets);
          
          //Iterate through all survivor spawns
          for(uint i = 0; i < potentialTargets.length; i++) {
            
            //Store a reference to this spawn blob object
            potentialTarget = potentialTargets[i];
            
            //Determine the distance
            f32 distance = (potentialTarget.getPosition() - blob.getPosition()).getLength();
            
            //Check if distance is shorter than any previous ones
            if(distance < shortestDistance || i == 0) {
              
              //Store a reference to this target object
              target = potentialTarget;
              
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
        
        break;
      
      case BRAINMODE_TARGETING:
      
        //Retrieve a reference to the target blob object
        target = getBlobByNetworkID(blob.get_netid("brain_target_id"));
          
        //Check if target is still within range
        if (target !is null && (target.getPosition() - blob.getPosition()).getLength() >= blob.get_f32("brain_target_radius")) {
        
          //Retrieve attack frequency variable
          u8 attackFrequency = blob.get_u8("brain_attack_frequency");
          
          //Retrieve attack time variable
          u16 attackTime = blob.get_u16("brain_attack_time");
        
          //Check if it's time to attack, and if target is within attack range (shape's radius)
          if((getGameTime()-attackTime) >= attackFrequency && (target.getPosition() - blob.getPosition()).getLength() >= blob.getRadius()) {
          
            //Create a vector
            Vec2f attackVector = target.getPosition()-blob.getPosition();
            
            //Normalize vector
            attackVector.Normalize();
            
            //Create an array of hit info object handles
            HitInfo@[] hitInfos;
            
            //Retrieve the map
            CMap@ map = getMap();
            
            //If hit info references could be obtained for an arc
            if (map.getHitInfosFromArc( blob.getPosition()-Vec2f(2,0).RotateBy(-attackVector.Angle()),-attackVector.Angle(),90,blob.getRadius()*2, blob, @hitInfos )) {
            
              //Create a handle for a blob object
              CBlob@ nearbyBlob;
            
              //Iterate through all hit info objects (closest first)
              for(uint i = 0; i < hitInfos.length; i++) {
              
                //Store blob reference
                nearbyBlob = hitInfos[i].blob;
                
                //Check if blob is the target
                if(nearbyBlob is target) {
                
                  //Retrieve attack damage variable
                  f32 attackDamage = blob.get_f32("brain_attack_damage");
                  
                  //Initiate bite attack
                  blob.server_Hit(target, target.getPosition(), attackVector, attackDamage, Hitters::bite, false);
              
                  //Update attack time variable
                  blob.set_u16("brain_attack_time", getGameTime());
                  
                  //Exit loop
                  break;
                  
                }
                
              }
            
            }
          
          }
          
          //Otherwise, if not attacking yet or if target is not within attack range
          else {
          
            //Pursue target by initiating movement through key press
            blob.setKeyPressed((target.getPosition().x < blob.getPosition().x) ? key_left : key_right, true);
            
          }
          
        }
        
        //Otherwise target is out of range
        else {
        
          //Set mode variable to invading mode
          blob.set_u8("brain_mode", BRAINMODE_INVADING);
          
        }
        
        break;
    
    }
    
  }
    
  //Save delay tracker variable
  blob.set_u8("brain_delay", brainDelay);
  
  //Finished

}