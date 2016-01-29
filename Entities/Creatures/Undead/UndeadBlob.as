/*
 * UndeadInvasion Undead blob
 * 
 * This script handles anything general.
 * 
 * NOTE: This script relies on the variables set in "UndeadVariables.as", and 
 *       must therefore be bundled together with it, or a derived version.
 * 
 * Author: ANybakk
 * Based on previous work by: Eanmig
 * 
 * TODO: Set mode to warm-up when last player leaves (Spawn system's job?)
 * TODO: Idea: Create player-controlled Undead entities
 */

#include "Hitters.as";



/**
 * Initialization event function
 */
void onInit(CBlob@ this) {
  
  //Set to not be in a usual player team (and not the same team as animals either)
	this.server_setTeamNum(-2);
  
  //Tag as undead (should normally not be changed)
  this.Tag("isUndead");
  
  //Activate brain
  this.getBrain().server_SetActive(true);
  
}



/**
 * Tick event function
 */
void onTick(CBlob@ this) {
  
  //Finished
  
}



/**
 * Hit event function
 */
 /*
f32 onHit(CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitterBlob, u8 customData) {

  //Take damage
  this.Damage(damage, hitterBlob);
  print("DMG recieved:"+damage+" Health:"+this.getHealth());
  //Finished, tell that no damage remains
  return 0.0f;
  
}*/



/**
 * pickup check function
 */
bool canBePickedUp(CBlob@ this, CBlob@ other) {
  
  //Finished, tell that this cannot be picked up
  return false;
  
}



/**
 * Collision check function
 */
bool doesCollideWithBlob(CBlob@ this, CBlob@ other) {
  
  //Finished, tell that this does collide
  return true;

}



/**
 * Collision event function
 * 
 * COMMENT: Is only called once per collision.
 * TODO: Consider if collision should cause a stumbling effect or something
 */
void onCollision(CBlob@ this, CBlob@ other, bool solid, Vec2f normal, Vec2f point1) {

  //Check if debug mode
  if(g_debug > 0) {
  
    //Store position of collision
    this.set_Vec2f("collidedWithPosition", point1);
    
  }

  //Determine if collision has a left component
  bool collidedLeft = normal.x > 0.0f;
  
  //Determine if collision has a right component
  bool collidedRight = normal.x < 0.0f;

  //Check if valid blob reference
  if(other !is null) {

    //Check if tagged as undead
    if(other.hasTag("isUndead")) {
    
      //Check if collision was in the facing direction
      if((this.isFacingLeft() && collidedLeft) || (!this.isFacingLeft() && collidedRight)) {
      
        //Set undead in front collision flag
        this.Tag("collidedWithUndeadInFront");
      
      }
      
    }
    
  }
  
  /* This does not really work. Collision is quite random, and the function is only called once
  //Check if solid block
  if(solid) {
  
    //Retrieve a reference to the map object
    CMap@ map = this.getMap();
    
    //Obtain a tile object
    Tile tile = map.getTile(point1);
    
    //Check if tile type is wood
    if(tile.type == CMap::tile_wood) {
    
      //Initiate tile destruction
      map.server_DestroyTile(point1, 0.1f, this);
      
    }
  
  }
  */

  //Finished
  return;
  
}



/**
 * Death event function
 */
void onDie(CBlob@ this) {

  //Drop coin(s) slightly above current position
  server_DropCoins(this.getPosition() + Vec2f(0,-3.0f), UndeadVariables::DROP_COIN_AMOUNT);
  
  //Initiate gibbing
  this.getSprite().Gib();
  
  //Finished
  return;

}