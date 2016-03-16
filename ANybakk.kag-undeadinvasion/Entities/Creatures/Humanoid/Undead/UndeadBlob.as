/* 
 * Undead blob script
 * 
 * Author: ANybakk
 */

#include "Undead.as"



//Called on initialization.
void onInit(CBlob@ this) {

  //Default data

  Undead::Data data();
  Undead::Blob::storeData(this, @data);
  
  //Data modifications
  
  //Initializations
  
  this.Tag("isUndead");
  
  //Set to not be in a usual player team (and not the same team as animals either)
  this.server_setTeamNum(data.oTeamNumber);
  
  //Activate brain
  this.getBrain().server_SetActive(true);
  
}



//Called on death/destruction.
void onDie(CBlob@ this) {
  
  //Retrieve data
  Undead::Data@ data = Undead::Blob::retrieveData(this);

  //Drop coin(s) slightly above current position
  server_DropCoins(this.getPosition() + Vec2f(0,-3.0f), data.oDropCoinAmount);
  
  //Initiate gibbing
  this.getSprite().Gib();
  
}



//Called on collision check.
bool doesCollideWithBlob(CBlob@ this, CBlob@ blob) {

  //Finished, tell that this collides
  return true;
  
}



//Called on collision.
void onCollision(CBlob@ this, CBlob@ blob, bool solid, Vec2f normal, Vec2f point1) {

  //TODO: Consider if collision should cause a stumbling effect or something
  
  if(g_debug > 0) { this.set_Vec2f("collidedWithPosition", point1); }
  
  //Retrieve data
  Undead::Data@ data = Undead::Blob::retrieveData(this);

  //Determine if collision has a left component
  bool collidedLeft = normal.x > 0.0f;
  
  //Determine if collision has a right component
  bool collidedRight = normal.x < 0.0f;
  
  bool collidedFacingDirection = (this.isFacingLeft() && collidedLeft) || (!this.isFacingLeft() && collidedRight);
  
  //Check if valid blob reference
  if(other !is null) {

    //Check if tagged as undead
    if(other.hasTag("isUndead")) {
    
      //Check if collision was in the facing direction
      if(collidedFacingDirection) {
      
        //Set undead in front collision flag
        data.iCollidedWithUndeadInFront = true;
      
      }
      
    }
    
  }
  
}



//Called on pickup check.
bool canBePickedUp(CBlob@ this, CBlob@ byBlob) {

  //Finished, tell that this cannot be picked up
  return false;
  
}