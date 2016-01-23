/*
 * UndeadInvasion Zombie blob
 * 
 * This script handles anything general.
 * 
 * Author: ANybakk
 * Based on previous work by: Eanmig
 * 
 * TODO:  Barely in use, because zombies do not revive, they do not drop coins 
 *        when killed, and they always collide
 * TODO:  Set mode to warm-up when last player leaves (Spawn system's job?)
 */

#include "ZombieVariables.as";

#include "Hitters.as";



/**
 * Initialization event function
 */

void onInit(CBlob@ this) {
  
  //Set rotting time variable
  //this.set_u8("zombie_rotting_time", ZombieVariables::ROTTING_TIME*getTicksASecond());
  
  //Set time of death variable
  //this.set_u16("time_of_death", 0);
  
  //Set to not be in a usual player team
	this.server_setTeamNum(-1);
  
}



/**
 * Tick event function
 */
/*
void onTick(CBlob@ this) {

  //Retrieve horizontal velocity
  //f32 x = this.getVelocity().x;

  //Check if zombie's health is depleted and is currently alive
  if(this.getHealth()<=0.0 && this.get_u16("time_of_death") == 0) {
  
    //Set health to 0.5 (keep alive)
    this.server_SetHealth(0.5);
    
    //Set time of death variable
    this.set_u16("time_of_death", getGameTime());
    
    //Set shape friction to 0.3
    this.getShape().setFriction( 0.3f );
    
    //Set shape elasticity to 0.1
    this.getShape().setElasticity( 0.1f );
    
  }
  
  //If zombie has been dead for more than set rotting time
  if(getGameTime() - this.get_u16("time_of_death")) < this.get_u8("zombie_rotting_time")) {
  
    //Set to die
    this.server_Die();
    
    
  }
  
  //Finished
  
}
*/



/**
 * Hit event function
 */
/*
f32 onHit(CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitterBlob, u8 customData) {		
  
  //Check if zombie is currently alive and dealt damage is fatal
  if(this.getHealth() > 0 && this.getHealth() <= damage) {
  
    //Check that this is the server
    if (getNet().isServer()) {
    
      //Set time of death variable to current time
      this.set_u16("time_of_death", getGameTime());
      
    }
    
    //Synchronize time of death variable
    //TODO: What does this call actually do?
    this.Sync("time_of_death", true);
    
  }

  //Check if hit by arrow
  if(customData == Hitters::arrow) {
    
    //Multiply damage by 2
    //damage*=2.0;
  
  }

  //Register dealt damage
  this.Damage(damage, hitterBlob);
  
  //Retrieve health threshold for gibs
  //TODO: Where is this variable set?
  f32 gibHealth = (this.exists("gib health")) ? this.get_f32("gib health") : 0.0f;
  
  //Check if health is below threshold 
  if(this.getHealth() <= gibHealth) {
    
    //Create a handle to a player object
    CPlayer@ player;
    
    //Check if hit source was a survivor
    if(hitterBlob.hasTag("player")) {
    
      //Obtain player object reference
      player = hitterBlob.getPlayer();
      
    }
    
    //Otherwise, check if hit source was owned by a survivor
    else if(hitterBlob.getDamageOwnerPlayer() !is null) {
    
      //Obtain player object reference
      player = hitterBlob.getDamageOwnerPlayer();
      
    }
    
    //Drop coins
    //server_DropCoins(hitterBlob.getPosition() + Vec2f(0,-3.0f), 10);
    
    //Initiate gib process
    this.getSprite().Gib();
    
    //Set to die
    this.server_Die();
    
  }
  
  //Tell that no damage remains
  return 0.0f;
  
  //Finished
  
}
*/



/**
 * pickup check function
 */
bool canBePickedUp(CBlob@ this, CBlob@ other) {

  //Determine if zombie has health left or if zombie is on the same team
  //return this.getHealth() < 0.0 || this.getTeamNum() == other.getTeamNum();
  
  //Tell that this cannot be picked up
  return false;
  
  //Finished
  
}



/**
 * Collision check function
 */
bool doesCollideWithBlob(CBlob@ this, CBlob@ other) {

  /*
  //Check if other tagged "dead"
  if(other.hasTag("dead")) {
  
    //Tell that this does not collide
    return false;
    
  }
  */
  
  /*
  //Check if other not tagged as zombie, tagged as flesh and is on the same team
  if(!other.hasTag("zombie") && other.hasTag("flesh") && this.getTeamNum() == other.getTeamNum()) {
  
    //Tell that this does not collide
    return false;
    
  }
  */
  
  /*
  //Check if other tagged as zombie and health depleted
  //(Does not include health exactly 0, and what about living corpse?)
  if(other.hasTag("zombie") && other.getHealth()<0.0) {
  
    //Tell that this does not collide
    return false;
    
  }
  */
  
  //Tell that this does collide
  return true;
  
  //Finished

}



/**
 * Collision event function
 * 
 * TODO: Consider if collision should cause a stumbling effect or something
 */
void onCollision(CBlob@ this, CBlob@ other, bool solid, Vec2f normal, Vec2f point1) {

  //Check if health is depleted
  if(this.getHealth() <= 0.0) {
    
    //Stop (is dead)
    return;
    
  }
  
  //Check if other is invalid/missing
  if(other is null) {
  
    //Stop
    return;
    
  }
  
  /*
  //Check if other is not on the same team, is tagged with "flesh" and isn't dead
  if(other.getTeamNum() != this.getTeamNum() && other.hasTag("flesh") && !other.hasTag("dead")) {
  
    //Target other
    
  }
  */
  
  //Finished
  
}



/**
 * Death event function
 */
void onDie(CBlob@ this) {
      
  //Set shape friction to 0.75
  //this.getShape().setFriction( 0.75f );
  
  //Set shape elasticity to 0.2
  //this.getShape().setElasticity( 0.2f );

  //Stop
  return;
  
  //Finished

}