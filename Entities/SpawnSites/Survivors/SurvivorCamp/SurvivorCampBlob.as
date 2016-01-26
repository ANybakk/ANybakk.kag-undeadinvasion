/*
 * UndeadInvasion SurvivorCamp blob
 * 
 * This script handles anything general.
 * 
 * Author: ANybakk
 */

#include "SurvivorCampVariables.as";

#include "StandardRespawnCommand.as";
#include "Help.as"



/**
 * Initialization event function
 */
void onInit(CBlob@ this) {

  //Set tick frequency to 30
  this.getCurrentScript().tickFrequency = 30;
  
  //??
  InitClasses(this);
  
  //Call respawn command initialization function (StandardRespawnCommand.as)
  InitRespawnCommand(this);
  
  //Add state command
  this.addCommandID("setSpriteFrame");

  //Add shipment command
  this.addCommandID("setShipment");

  //Set besieged time variable
  this.set_f32("besieged_time", 0.0f);
  
  //Set the background tiles to be stone back wall
  this.set_TileType("background tile", CMap::tile_castle_back);
  
  //Tag blob so that inventory is stored on class change (StandardRespawnCommand.as)
  this.Tag("change class store inventory");
  
  //Set to snap icons on mini-map edge
  this.SetMinimapOutsideBehaviour(CBlob::minimap_snap);
  
  //Set minimap to always be rendered
	this.SetMinimapRenderAlways(true);
  
  //??
  this.inventoryButtonPos = Vec2f(24, -14);
  
  //??
  this.set_Vec2f("travel button pos", Vec2f(-12, 7));
  
  //??
  this.Tag("storage");	 // gives spawn mats
  
  //??
  this.getShape().getConsts().waterPasses = false;

  // defaultnobuild
  //??
  this.set_Vec2f("nobuild extend", Vec2f(0.0f, 8.0f));

  // wont work in basichelps in single for some map loading reason
  //??
  SetHelp(this, "help use", "", "Change class    $KEY_E$", "", 5);
  
  //Finished
  
}



/**
 * Tick event function
 */
void onTick(CBlob@ this) {
  
  //Check if server-side
  if(getNet().isServer()) {
  
    //Check if under siege
    if(this.hasTag("besieged")) {
  
      //Obtain current time
      f32 currentTime = getGameTime();
    
      //Get besieged time variable
      f32 besiegedTime = this.get_f32("besieged_time");
      
      //Check if alert period is over
      if(currentTime-besiegedTime > SurvivorCampVariables::BESIEGED_ALERT_TIMEOUT*getTicksASecond()) {
      
        //Remove besieged flag
        this.Untag("besieged");
        
        //TODO: Is it necessary to synchronize tag?
      
      }
      
    }
    
  }
  
  //Finished

}



/**
 * Command event function
 */
void onCommand(CBlob@ this, u8 cmd, CBitStream @params) {

  //Check if setSpriteFrame (is this going to be used?)
  if (cmd == this.getCommandID("setSpriteFrame")) {
    
    //Set sprite animation frame
    this.getSprite().animation.frame = params.read_u8();
    
  }

  //Otherwise, check if shipment
  else if (cmd == this.getCommandID("setShipment")) {
  
    //Obtain a reference to the local player's blob
    CBlob@ localPlayerBlob = getLocalPlayerBlob();
    
    //Check if a reference is valid and that the the player is on the same team
    if (localPlayerBlob !is null && localPlayerBlob.getTeamNum() == this.getTeamNum()) {
    
      //Add notification about shipment to client chat
      client_AddToChat("Supplies will drop at your base.");
      
    }
    
  }

  //Otherwise
  else {

    //Call function for standard commands (StandardRespawnCommand.as)
    onRespawnCommand(this, cmd, params);

  }
  
  //Finished
  
}



/**
 * Hit event function
 */
f32 onHit(CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitterBlob, u8 customData) {
  
  //Check if server-side
  //if(getNet().isServer()) {
    
    //Tag as besieged
    this.Tag("besieged");
    
    //Set besieged time
    this.set_f32("besieged_time", getGameTime());
    
  //}

  //Register dealt damage
  this.Damage(damage, hitterBlob);
  
  //Tell that no damage remains
  return 0.0f;
  
  //Finished
  
}



/**
 * Inventory accessibility check function
 */
bool isInventoryAccessible(CBlob@ this, CBlob@ forBlob) {

  //Tell if on same team and overlapping
  return forBlob.getTeamNum() == this.getTeamNum() && forBlob.isOverlapping(this);

}