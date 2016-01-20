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



const f32 movement_factor_water_x = 0.23f;
const f32 movement_factor_water_y = 0.23f;



/**
 * Variable collection class
 */
shared class ZombieMovementVariables {
	Vec2f walkForce;  
	Vec2f runAcceleration;
	Vec2f slowFactor;
	Vec2f jumpAcceleration;
	f32 maxVelocity;
};



/**
 * Initialization event funcion
 */
void onInit(CMovement@ this) {

  //Obtain a reference to the blob object
  CBlob@ blob = this.getBlob();

  //Create variable collection
	ZombieMovementVariables movementVariables;
  
  //Set walking force variable 
  movementVariables.walkForce.Set( 4.0f, 0.0f  );

  //Set running force variable 
  movementVariables.runAcceleration.Set(  4.0f, 0.0f  );

  //Set slowing force variable 
  movementVariables.slowFactor.Set( 2.0f, 0.0f  );

  //Set jumping force variable 
  movementVariables.jumpAcceleration.Set( 0.0f, -1.6f );

  //Set maximum force variable 
  movementVariables.maxVelocity =  0.5f;
  
  //Store variable collection
	blob.set("movement-variables", movementVariables);
  
  //Store climbing counting variable to 0
	//this.set_s32("movement-climb", 0);

  //Set tick not attached flag
  this.getCurrentScript().runFlags |= Script::tick_not_attached;
  
  //Set remove on "dead" tag
  this.getCurrentScript().removeIfTag	= "dead";
  
}



/**
 * Tick event function
 */
void onTick(CMovement@ this) {

  //Retrieve blob object reference
  CBlob@ blob = this.getBlob();
  
  //Retrieve movement variable collection
  ZombieMovementVariables@ movementVariables;
  
  //Check that movement variables can be retrieved
  if (!blob.get( "movement-variables", @movementVariables )) {
  
    //Stop (does not have the necessary variables)
    return;
    
  }
  
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
  
    //Add a force to the left
    blob.AddForce(Vec2f( -1.0f * movementVariables.walkForce.x, movementVariables.walkForce.y));
    
  }
  
  //Check if right key action
  if(rightAction) {
  
    //Add a force to the right
    blob.AddForce(Vec2f( 1.0f * movementVariables.walkForce.x, movementVariables.walkForce.y));
    
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
          environmentalFactor.Set(movement_factor_water_x, movement_factor_water_y);
        }
        
        //Calculate horizontal force
        f32 horizontalForce = blob.getMass() * movementVariables.jumpAcceleration.x * environmentalFactor.x;
        
        //Calculate vertical force
        f32 verticalForce = blob.getMass() * movementVariables.jumpAcceleration.y * environmentalFactor.y;
        
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
  if(shape.vellen > movementVariables.maxVelocity) {
  
    //Retrieve current velocity
    Vec2f velocity = blob.getVelocity();
    
    //Add a slowing-down force
    blob.AddForce( Vec2f(-velocity.x * movementVariables.slowFactor.x, -velocity.y * movementVariables.slowFactor.y) );
    
  }
  
  //Finished
  
}