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
  
  //Tag as survivor spawn (should normally not be changed)
  this.Tag("isSurvivorSpawn");
  
  //??
  InitClasses(this);
  
  //Call respawn command initialization function (StandardRespawnCommand.as)
  InitRespawnCommand(this);
  
  //Add state command
  this.addCommandID("setSpriteFrame");

  //Add shipment command
  this.addCommandID("setShipment");

  //Set besieged time variable
  this.set_u32("besiegedTime", 0.0f);
  
  //Set the background tiles to be stone back wall
  this.set_TileType("background tile", CMap::tile_wood_back);
  
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

  //Set an extended no-build zone for floor tiles below
  this.set_Vec2f("nobuild extend", Vec2f(0.0f, 0.0f + this.getMap().tilesize));

  // wont work in basichelps in single for some map loading reason
  //??
  SetHelp(this, "help use", "", "Change class    $KEY_E$", "", 5);
  
  //Finished
  
}



/**
 * Tick event function
 */
void onTick(CBlob@ this) {
  
  //Check if under siege
  if(this.hasTag("besieged")) {
  
    //Determine for how long besiege alert have been active
    u32 besiegedBesiegedAlertTime = getGameTime() - this.get_u32("besiegedTime");
    
    //Check if alert period is over
    if(besiegedBesiegedAlertTime > SurvivorCampVariables::BESIEGED_ALERT_TIMEOUT * getTicksASecond()) {
    
      //Remove besieged flag
      this.Untag("besieged");
    
    }
    
  }
  
  u8 teamNumber = this.getTeamNum();
  
  CMap@ map = this.getMap();
  
  //Create an array of blob references
  CBlob@[] nearbyBlobs;
  
  //Create a blob handle
  CBlob@ nearbyBlob;
  
  //Check if any blobs within radius
  if(map.getBlobsInRadius(this.getPosition(), SurvivorCampVariables::BESIEGED_RADIUS, @nearbyBlobs)) {
  
    //Create status for undead
    bool isUndead = false;
    
    //Create status for player
    bool isPlayer = false;
    
    //Create status for dead
    bool isDead;
    
    //Iterate through blobs
    for(uint i=0; i<nearbyBlobs.length; i++) {
    
      //Keep a reference to this blob
      @nearbyBlob = nearbyBlobs[i];
      
      //Determine if undead
      isUndead = nearbyBlob.hasTag("isUndead");
      
      //Determine if player
      isPlayer = nearbyBlob.hasTag("player");
      
      //Determine if dead
      isDead = nearbyBlob.hasTag("dead");
      
      //Check if blob is a player, not undead, and not dead
      if(isPlayer && !isUndead && !isDead) {
      
        //Check if spawn site has no owner
        if(teamNumber > 10) {
        
          //Change ownership
          UndeadInvasion::SurvivorCampBlob::changeOwnership(this, nearbyBlob.getTeamNum());
          
        }
        
        //Otherwise, besieged
        else {
        
          //TODO: Do defenders v.s. attackers evaluations like in Hall.as
          
        }
        
      }
      
    }
    
  }
  
  //Finished
  return;

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

  if(hitterBlob.hasTag("isUndead")) {
  
    //Tag as besieged
    this.Tag("besieged");
    
    //Set besieged time
    this.set_u32("besiegedTime", getGameTime());

    //Register dealt damage
    this.Damage(damage, hitterBlob);
    
  }
  
  //Finished, return no damage remaining
  return 0.0f;
  
}



void onChangeTeam(CBlob@ this, const int oldTeam) {

  //Set changed ownership flag
  this.Tag("changedOwnership");
  
}



/**
 * Inventory accessibility check function
 */
bool isInventoryAccessible(CBlob@ this, CBlob@ forBlob) {

  //Tell if on same team and overlapping
  return forBlob.getTeamNum() == this.getTeamNum() && forBlob.isOverlapping(this);

}



namespace UndeadInvasion {

  namespace SurvivorCampBlob {
  
  
  
    /**
     * Changes ownership of this spawn site and nearby structures
     * 
     * @param   this        blob reference.
     * @param   teamNumber  the new team owner
     */
    void changeOwnership(CBlob@ this, const u8 teamNumber) {
    
      //Check if server
      if (getNet().isServer()) {
      
        CMap@ map = this.getMap();
        
        //Create an array of blob references
        CBlob@[] nearbyBlobs;
        
        //Obtain blob references within a radius
        if(map.getBlobsInRadius(this.getPosition(), SurvivorCampVariables::TERRITORY_RADIUS, @nearbyBlobs)) {
        
          //Create a blob handle
          CBlob@ nearbyBlob;
        
          //Iterate through nearby blobs
          for(uint i=0; i<nearbyBlobs.length; i++) {
          
            //Keep a reference to blob
            @nearbyBlob = nearbyBlobs[i];
            
            //Check if blob's owner is not same as new owner and is either a door or a building
            if(nearbyBlob.getTeamNum() != teamNumber && (nearbyBlob.hasTag("door") || nearbyBlob.hasTag("building"))) {
            
              //Set ownership on blob
              nearbyBlob.server_setTeamNum(teamNumber);
              
            }
            
          }
          
        }
        
      }
      
      //Set ownership of spawn site
      this.server_setTeamNum(teamNumber);
      
    }
    
    
    
  }
  
}