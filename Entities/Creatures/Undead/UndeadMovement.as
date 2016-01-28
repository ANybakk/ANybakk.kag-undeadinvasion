/*
 * UndeadInvasion Undead movement
 * 
 * This script handles anything to do with movement. An undead will move either 
 * left or right, and if an obstacle is found, a jump is performed.
 * 
 * NOTE: This script relies on the variables set in "UndeadVariables.as", and 
 *       must therefore be bundled together with it, or a derived version.
 * 
 * TODO: Make zombies able to jump over each other if they aren't making progress
 * TODO: Make zombies unable to jump if another undead is standing on top
 * TODO: Sometimes zombies jump too high
 * 
 * Author: ANybakk
 * Based on previous work by: Eanmig
 */

#define SERVER_ONLY

#include "UndeadBrainMode.as";



/**
 * Initialization event funcion
 */
void onInit(CMovement@ this) {

  //Obtain a reference to the blob object
  CBlob@ blob = this.getBlob();
  
  //Store climbing counting variable to 0
	//this.set_s32("movement-climb", 0);

  //Set tick not attached flag
  //this.getCurrentScript().runFlags |= Script::tick_not_attached;
  
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
  //TODO: Isn't this redundant?
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
    if(blob.isOnGround() || blob.isInWater()) {
      
      //Retrieve left neighbouring tile
      Tile leftNeighbourTile = map.getTile(Vec2f(currentPosition.x - (radius+1.0f), currentPosition.y));
    
      //Retrieve right neighbouring tile
      Tile rightNeighbourTile = map.getTile(Vec2f(currentPosition.x + (radius+1.0f), currentPosition.y));
    
      //Determine left blocked status
      bool leftBlocked = map.isTileSolid( leftNeighbourTile );
      
      //Determine right blocked status
      bool rightBlocked = map.isTileSolid( rightNeighbourTile );
      
      //Determine if blob recently collided with another undead blob
      bool collidedWithUndeadInFront = blob.hasTag("collidedWithUndeadInFront");
      
      //Check if action is blocked by a solid object or collided with another undead
      if((leftAction && (leftBlocked || collidedWithUndeadInFront)) || (rightAction && (rightBlocked || collidedWithUndeadInFront))) {
        
        //Press up key (handled on next tick)
        blob.setKeyPressed(key_up, true);
        
        //Untag collision status
        blob.Untag("collidedWithUndeadInFront");
        
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
  
  //Finished
  
}