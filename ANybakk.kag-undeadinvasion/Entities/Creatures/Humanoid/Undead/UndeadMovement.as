/* 
 * Undead movement script
 * 
 * Author: ANybakk
 */

#include "Undead.as"
#include "Humanoid.as"
#include "UndeadInvasionMap.as" //?



//Called on initialization.
void onInit(CMovement@ this) {

  //Obtain blob reference
  CBlob@ blob = this.getBlob();
  
  //Retrieve data
  Undead::Data@ data = Undead::Blob::retrieveData(blob);
  
  //Set collateral attack time tracking variable to current time
  data.iLastCollateralAttackTime = getGameTime();
  
  //Set remove on "dead" tag
  this.getCurrentScript().removeIfTag	= "dead";
  
}

//Called on every tick.
void onTick(CMovement@ this) {

  //Obtain blob reference
  CBlob@ blob = this.getBlob();
  
  //Retrieve data
  Undead::Data@ data = Undead::Blob::retrieveData(blob);
  
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
  
  //Retrieve down key action
  bool downAction = blob.isKeyPressed(key_down);

  //Retrieve velocity
  Vec2f vel = blob.getVelocity();
  
  //Create an acceleration value, default walking
  Vec2f acceleration = data.oMovementWalkAcceleration;
  
  //Check if brain is in targeting mode
  if(data.iMode == Undead::Mode::MODE_TARGETING) {
  
    //Set acceleration value to running
    acceleration = data.oMovementRunAcceleration;
    
  }
      
  //Create a environmental factor
  Vec2f environmentalFactor(1.0f, 1.0f);
  
  //Check if currently in water
  if(blob.isInWater()) {
  
    //Set environmental factor
    environmentalFactor = data.oMovementFactorWater;
    
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
    f32 horizontalForce = blob.getMass() * data.oMovementJumpAcceleration.x * environmentalFactor.x;
    
    //Calculate vertical force
    f32 verticalForce = blob.getMass() * data.oMovementJumpAcceleration.y * environmentalFactor.y;
    
    //Add a jumping force
    blob.AddForce(Vec2f( horizontalForce, verticalForce));
    
    //Set jumped flag
    data.iHasJumped = true;
    
    //Stop pressing up key
    blob.setKeyPressed(key_up, false);
  
  }
  
  //Otherwise, if not up key action
  else {
      
    //Check if currently on ground
    //COMMENT: Standing on top of another undead seems to be considered standing on the ground
    if(blob.isOnGround()) {
        
      //Retrieve map object reference
      CMap@ map = blob.getMap();
          
      //Get a 2D array of vectors representing all the possible neighbour tile positions
      Vec2f[][] neighbourTilePositions = Humanoid::Blob::getNeighbourTilePositions(blob);
      
      //Get a 2D array of neighbour tiles (same sequence)
      Tile[][] neighbourTiles = UndeadInvasionMap::getTiles(map, neighbourTilePositions);
      
      //Check if left or right up key action
      if (leftAction || rightAction) {
        
        //Determine left blocked status (either tile is solid)
        bool leftWalkBlocked = map.isTileSolid(neighbourTiles[3][0]) || map.isTileSolid(neighbourTiles[3][0]);
        
        //Determine right blocked status (either tile is solid)
        bool rightWalkBlocked = map.isTileSolid(neighbourTiles[1][1]) || map.isTileSolid(neighbourTiles[1][1]);
        
        //Determine if blob recently collided with another undead blob
        bool collidedWithUndeadInFront = data.iCollidedWithUndeadInFront;
        
        //Check if action is blocked by a solid object or collided with another undead
        if((leftAction && (leftWalkBlocked || collidedWithUndeadInFront)) || (rightAction && (rightWalkBlocked || collidedWithUndeadInFront))) {
          
          //Press up key (handled on next tick)
          blob.setKeyPressed(key_up, true);
          
          //Unset collision status flag
          data.iCollidedWithUndeadInFront = false;
          
        }
        
      }
      
      //Determine collateral attack frequency
      f32 collateralAttackFrequency = data.oCollateralAttackFrequency * getTicksASecond();
      
      //Retrieve collateral attack time variable
      u32 collateralAttackTime = data.iLastCollateralAttackTime;
      
      //Determine if it's time to attack, by checking lapsed time against frequency
      bool isTimeToAttack = (getGameTime() - collateralAttackTime) >= collateralAttackFrequency;
      
      //Check if time to attack
      if(isTimeToAttack) {
      
        //Create a boolean array for which directions to enable collateral damage for
        bool[] doCollateralDamage;
        
        //Enable collateral damage above if up action
        //TODO: Doesn't seem to happen anyway?
        doCollateralDamage.push_back((upAction) ? true : false);
        
        //Enable collateral damage to the right if right action
        doCollateralDamage.push_back((rightAction) ? true : false);
        
        //Enable collateral damage below if down action
        doCollateralDamage.push_back((downAction) ? true : false);
        
        //Enable collateral damage to the left if left action
        doCollateralDamage.push_back((leftAction) ? true : false);
      
        //Create a tile object handle
        Tile tile;
        
        //Iterate through neighbour tile directions
        for(int i=0; i<neighbourTiles.length; i++) {
        
          //Check if this direction is enabled for collateral damage
          if(doCollateralDamage[i]) {
          
            //Iterate through all tiles
            for(int j=0; j<neighbourTiles[i].length; j++) {
            
              //Store a reference to the tile object
              tile = neighbourTiles[i][j];
              
              //Check if wood or dirt tile
              if(map.isTileWood(tile.type) || tile.type == CMap::tile_ground) {
            
                //Initiate tile destruction
                map.server_DestroyTile(neighbourTilePositions[i][j], data.oCollateralAttackDamage, blob);
                
                //Update collateral attack time variable
                data.iLastCollateralAttackTime = getGameTime();
                
              }
              
            }
            
          }
          
        }
        
        //TODO: Check if door
        
      }
      
    }
  
  }
  
  //Retrieve a reference to the shape object
  CShape@ shape = blob.getShape();

  //Check if velocity exceeds the maximum velocity variable
  //COMMENT: Why not blob.getVelocity()? CShape is undocumented.
  if(shape.vellen > data.oMovementMaxVelocity) {
  
    //Retrieve current velocity
    Vec2f velocity = blob.getVelocity();
    
    //Add a slowing-down force
    blob.AddForce( Vec2f(-velocity.x * data.oMovementFactorSlowdown.x, -velocity.y * data.oMovementFactorSlowdown.y) );
    
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