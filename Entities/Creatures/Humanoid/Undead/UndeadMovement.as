/*
 * UndeadInvasion Undead movement
 * 
 * This script handles anything to do with movement. An undead will move either 
 * left or right, and if an obstacle is found, a jump is performed.
 * 
 * NOTE: This script relies on the variables set in "UndeadVariables.as", and 
 *       must therefore be bundled together with it, or a derived version.
 * TODO: Set a tick frequency?
 * TODO: Make undead jump if their target in targeting mode is above them.
 * 
 * Author: ANybakk
 * Based on previous work by: Eanmig
 */

#define SERVER_ONLY

#include "UndeadBrainMode.as";
#include "HumanoidBlob.as";
#include "UndeadInvasionMap.as";



/**
 * Initialization event funcion
 */
void onInit(CMovement@ this) {

  //Obtain a reference to the blob object
  CBlob@ blob = this.getBlob();
  
  //Set collateral attack time tracking variable to current time
  blob.set_u16("lastCollateralAttackTime", getGameTime());
  
  //Set remove on "dead" tag
  this.getCurrentScript().removeIfTag	= "dead";
  
}



/**
 * Tick event function
 */
void onTick(CMovement@ this) {

  //Retrieve blob object reference
  CBlob@ blob = this.getBlob();
  
  //Check if health is depleted
  //COMMENT: Isn't this redundant?
  if (blob.getHealth() <= 0.0) {
  
    //Stop (dead)
    return;
    
  }
  
  //Retrieve left key action
  const bool leftAction = blob.isKeyPressed(key_left);
  
  //Retrieve right key action
  const bool rightAction = blob.isKeyPressed(key_right);
  
  //Retrieve up key action
  bool upAction = blob.isKeyPressed(key_up);

  //Retrieve velocity
  Vec2f vel = blob.getVelocity();
  
  //Retrieve brain mode variable
  u8 brainMode = blob.get_u8("brainMode");
  
  //Create an acceleration value, default walking
  Vec2f acceleration = UndeadVariables::MOVEMENT_WALK_ACCELERATION;
  
  //Check if brain is in targeting mode
  if(brainMode == UndeadBrainMode::MODE_TARGETING) {
  
    //Set acceleration value to running
    acceleration = UndeadVariables::MOVEMENT_RUN_ACCELERATION;
    
  }
      
  //Create a environmental factor
  Vec2f environmentalFactor(1.0f, 1.0f);
  
  //Check if currently in water
  if(blob.isInWater()) {
  
    //Set environmental factor
    environmentalFactor = UndeadVariables::MOVEMENT_FACTOR_WATER;
    
  }
  
  //Check if left key action
  if(leftAction) {
  
    //Set facing direction to left
    blob.SetFacingLeft(true);
    
    //Add a force to the left
    blob.AddForce(Vec2f( -1.0f * acceleration.x * environmentalFactor.x, acceleration.y * environmentalFactor.y));
    
  }
  
  //Check if right key action
  if(rightAction) {
  
    //Set facing direction to right
    blob.SetFacingLeft(false);
  
    //Add a force to the right
    blob.AddForce(Vec2f( 1.0f * acceleration.x * environmentalFactor.x, acceleration.y * environmentalFactor.y));
    
  }
  
  //Check if up key action
  if(upAction) {
    
    //Calculate horizontal force
    f32 horizontalForce = blob.getMass() * UndeadVariables::MOVEMENT_JUMP_ACCELERATION.x * environmentalFactor.x;
    
    //Calculate vertical force
    f32 verticalForce = blob.getMass() * UndeadVariables::MOVEMENT_JUMP_ACCELERATION.y * environmentalFactor.y;
    
    //Add a jumping force
    blob.AddForce(Vec2f( horizontalForce, verticalForce));
    
    //Set jumped flag
    blob.set_bool("hasJumped", true);
    
    //Stop pressing up key
    blob.setKeyPressed(key_up, false);
  
  }

  //Otherwise, check if left or right up key action (ignore if up action)
  else if (leftAction || rightAction) {
  
    //Retrieve current position
    Vec2f currentPosition = blob.getPosition();
    
    //Retrieve map object reference
    CMap@ map = blob.getMap();
    
    //Retrieve radius
    const f32 radius = blob.getRadius();
    
    //Check if currently on ground or in water
    //COMMENT: Standing on top of another undead seems to be considered standing on the ground
    if(blob.isOnGround() || blob.isInWater()) {
      
      //Get a 2D array of vectors representing all the possible neighbour tile positions
      Vec2f[][] neighbourTilePositions = UndeadInvasion::HumanoidBlob::getHorizontalNeighbourTilePositions(blob);
      
      //Get a 2D array of neighbour tiles (same sequence)
      Tile[][] neighbourTiles = UndeadInvasion::Map::getTiles(map, neighbourTilePositions);
      
      //Determine left blocked status
      bool leftWalkBlocked = map.isTileSolid(neighbourTiles[0][0]);
      
      //Determine right blocked status
      bool rightWalkBlocked = map.isTileSolid(neighbourTiles[1][0]);
      
      //Determine if blob recently collided with another undead blob
      bool collidedWithUndeadInFront = blob.hasTag("collidedWithUndeadInFront");
      
      //Check if action is blocked by a solid object or collided with another undead
      if((leftAction && (leftWalkBlocked || collidedWithUndeadInFront)) || (rightAction && (rightWalkBlocked || collidedWithUndeadInFront))) {
        
        //Press up key (handled on next tick)
        blob.setKeyPressed(key_up, true);
        
        //Turn off collision status flag
        blob.Untag("collidedWithUndeadInFront");
        
      }
      
      //Determine collateral attack frequency
      u8 collateralAttackFrequency = UndeadVariables::COLLATERAL_ATTACK_FREQUENCY * getTicksASecond();
      
      //Retrieve collateral attack time variable
      u16 collateralAttackTime = blob.get_u16("lastCollateralAttackTime");
      
      //Determine if it's time to attack, by checking lapsed time against frequency
      bool isTimeToAttack = (getGameTime() - collateralAttackTime) >= collateralAttackFrequency;
      
      //Check if time to attack
      if(isTimeToAttack) {
      
        //Create a tile object handle
        Tile tile;
        
        //Iterate through directions
        for(int i=0; i<neighbourTiles.length; i++) {
        
          //Check if this direction is blocked
          if(i == 0 && leftWalkBlocked || i == 1 && rightWalkBlocked) {
          
            //Iterate through all tiles
            for(int j=0; j<neighbourTiles[i].length; j++) {
            
              //Store a reference to the tile object
              tile = neighbourTiles[i][j];
              
              //Check if wood tile
              if(map.isTileWood(tile.type)) {
            
                //Initiate tile destruction
                map.server_DestroyTile(neighbourTilePositions[i][j], UndeadVariables::COLLATERAL_ATTACK_DAMAGE, blob);
                
                //Update collateral attack time variable
                blob.set_u16("lastCollateralAttackTime", getGameTime());
                
              }
              
            }
            
          }
          
        }
        
      }
      
    }
    
  }
  
  //Retrieve a reference to the shape object
  CShape@ shape = blob.getShape();

  //Check if velocity exceeds the maximum velocity variable
  //COMMENT: Why not blob.getVelocity()? CShape is undocumented.
  if(shape.vellen > UndeadVariables::MOVEMENT_MAX_VELOCITY) {
  
    //Retrieve current velocity
    Vec2f velocity = blob.getVelocity();
    
    //Add a slowing-down force
    blob.AddForce( Vec2f(-velocity.x * UndeadVariables::MOVEMENT_FACTOR_SLOWDOWN.x, -velocity.y * UndeadVariables::MOVEMENT_FACTOR_SLOWDOWN.y) );
    
  }
  
  //Create an array of blob references
  CBlob@[] overlappingBlobs;
  
  //Retrieve overlapping blobs
  blob.getOverlapping(@overlappingBlobs);
  
  //Iterate through all overlapping blobs
  for(int i=0; i<overlappingBlobs.length; i++) {
  
    //Otherwise, check if tagged as food
    if(overlappingBlobs[i].hasTag("food")) {

      //Initiate pick up
      //TODO: Doesn't seem to work
      blob.server_Pickup(overlappingBlobs[i]);

    }
  
  }
  
  //Finished
  return;
  
}