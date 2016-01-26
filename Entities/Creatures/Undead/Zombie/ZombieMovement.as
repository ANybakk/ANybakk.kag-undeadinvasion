/*
 * UndeadInvasion Zombie movement
 * 
 * This script handles anything to do with movement. A zombie will move either 
 * left or right, and if an obstacle is found, a jump is performed.
 * 
 * Author: ANybakk
 * Based on previous work by: Eanmig
 */

#define SERVER_ONLY

#include "ZombieVariables.as";



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
  
  //Check if left key action
  if(leftAction) {
  
    //Set facing direction to left
    blob.SetFacingLeft(true);
    
    //Add a force to the left
    blob.AddForce(Vec2f( -1.0f * ZombieVariables::MOVEMENT_WALK_ACCELERATION.x, ZombieVariables::MOVEMENT_WALK_ACCELERATION.y));
    
  }
  
  //Check if right key action
  if(rightAction) {
  
    //Set facing direction to right
    blob.SetFacingLeft(false);
  
    //Add a force to the right
    blob.AddForce(Vec2f( 1.0f * ZombieVariables::MOVEMENT_WALK_ACCELERATION.x, ZombieVariables::MOVEMENT_WALK_ACCELERATION.y));
    
  }

  // jump if blocked

  //Check if either left, right or up action
  if (leftAction || rightAction || upAction) {
  
    //Retrieve current position
    Vec2f currentPosition = blob.getPosition();
    
    //Retrieve map object reference
    CMap@ map = blob.getMap();
    
    //Retrieve radius
    const f32 radius = blob.getRadius();
    
    //
    //if (blob.isOnGround()) blob.set_s32("climb",1);
    
    //Check if currently on ground or in water
    if((blob.isOnGround() || blob.isInWater())) {
    
      //Determine left blocked status
      bool leftBlocked = map.isTileSolid( Vec2f( currentPosition.x - (radius+1.0f), currentPosition.y ));
      
      //Determine right blocked status
      bool rightBlocked = map.isTileSolid( Vec2f( currentPosition.x + (radius+1.0f), currentPosition.y ));
      
      //Check if action is up or action is blocked by a solid object
      if(upAction || (leftAction && leftBlocked) || (rightAction && rightBlocked)) {
      
        //Create a environmental factor
        Vec2f environmentalFactor(1.0f, 1.0f);
        
        //Check if currently in water
        if(blob.isInWater()) {
        
          //Set environmental factor
          environmentalFactor.Set(ZombieVariables::MOVEMENT_FACTOR_WATER.x, ZombieVariables::MOVEMENT_FACTOR_WATER.y);
          
        }
        
        //Calculate horizontal force
        f32 horizontalForce = blob.getMass() * ZombieVariables::MOVEMENT_JUMP_ACCELERATION.x * environmentalFactor.x;
        
        //Calculate vertical force
        f32 verticalForce = blob.getMass() * ZombieVariables::MOVEMENT_JUMP_ACCELERATION.y * environmentalFactor.y;
        
        //Add a jumping force
        blob.AddForce(Vec2f( horizontalForce, verticalForce));
        
        //blob.set_s32("climb",1);
      
      }
    
    }
    
  }
  
  //Retrieve a reference to the shape object
  CShape@ shape = blob.getShape();

  //Check if velocity exceeds the maximum velocity variable
  //COMMENT: Why not blob.getVelocity()? CShape is undocumented.
  if(shape.vellen > ZombieVariables::MOVEMENT_MAX_VELOCITY) {
  
    //Retrieve current velocity
    Vec2f velocity = blob.getVelocity();
    
    //Add a slowing-down force
    blob.AddForce( Vec2f(-velocity.x * ZombieVariables::MOVEMENT_FACTOR_SLOWDOWN.x, -velocity.y * ZombieVariables::MOVEMENT_FACTOR_SLOWDOWN.y) );
    
  }
  
  //Finished
  
}