/*
 * UndeadInvasion SurvivorCamp blob
 * 
 * This script handles anything general.
 * 
 * Author: ANybakk
 */

#include "SurvivorCampVariables.as";

#include "ClassSelectMenu.as";
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
  //this.addCommandID("setSpriteFrame");

  //Add shipment command
  //this.addCommandID("setShipment");

  //Set besieged time variable
  this.set_u32("besiegedTime", 0);
  
  //Set the background tiles to be wood back wall
  this.set_TileType("background tile", SurvivorCampVariables::BACKWALL_TYPE);
  
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
  this.getShape().getConsts().waterPasses = false;

  //Set an extended no-build zone for floor tiles below
  this.set_Vec2f("nobuild extend", Vec2f(0.0f, 0.0f + this.getMap().tilesize));

  // wont work in basichelps in single for some map loading reason
  //??
  SetHelp(this, "help use", "", "Change class    $KEY_E$", "", 5);
  
  //Finished
  return;
  
}



/**
 * Tick event function
 */
void onTick(CBlob@ this) {

  //Remove window (created by DefaultBuilding.as)
  Vec2f windowPosition = this.getPosition() - Vec2f(0, 4);
  getMap().server_SetTile(windowPosition, SurvivorCampVariables::BACKWALL_TYPE);
  
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
  
  //Obtain this spawn site's team 
  u8 ownerTeamNumber = this.getTeamNum();
  
  //Create an array of blob references
  CBlob@[] overlappingBlobs;
  
  //Create a blob handle
  CBlob@ overlappingBlob;
  
  //Check if any overlapping blobs
  if(this.getOverlapping(@overlappingBlobs)) {
  
    //Create status for undead
    bool isUndead = false;
    
    //Create status for player
    bool isPlayer = false;
    
    //Create status for dead
    bool isDead;
    
    //Iterate through blobs
    for(uint i=0; i<overlappingBlobs.length; i++) {
    
      //Keep a reference to this blob
      @overlappingBlob = overlappingBlobs[i];
      
      //Determine if undead
      isUndead = overlappingBlob.hasTag("isUndead");
      
      //Determine if player
      isPlayer = overlappingBlob.hasTag("player");
      
      //Determine if dead
      isDead = overlappingBlob.hasTag("dead");
      
      //TODO: Do defenders v.s. attackers evaluations like in Hall.as
      
      //Check if spawn site has no owner, overlapping is player and not dead
      if(ownerTeamNumber > 10 && isPlayer && !isDead) {
      
        //Change ownership
        UndeadInvasion::SurvivorCampBlob::changeOwnership(this, overlappingBlob.getTeamNum());
        
        this.Untag("besieged");
        
      }
      
      //Otherwise, check if different team
      else if(overlappingBlob.getTeamNum() != ownerTeamNumber) {
        
        this.Tag("besieged");
        
      }
      
      //Otherwise
      else {
        
        this.Untag("besieged");
        
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
  //if (cmd == this.getCommandID("setSpriteFrame")) {
    
    //Set sprite animation frame
    //this.getSprite().animation.frame = params.read_u8();
    
  //}

  //Otherwise, check if shipment
  //else if (cmd == this.getCommandID("setShipment")) {
  
    //Obtain a reference to the local player's blob
    //CBlob@ localPlayerBlob = getLocalPlayerBlob();
    
    //Check if a reference is valid and that the the player is on the same team
    //if(localPlayerBlob !is null && localPlayerBlob.getTeamNum() == this.getTeamNum()) {
    
      //Add notification about shipment to client chat
      //client_AddToChat("Supplies will drop at your base.");
      
    //}
    
  //}

  //Otherwise
  //else {

    //Call function for standard commands (StandardRespawnCommand.as)
    onRespawnCommand(this, cmd, params);

  //}
  
  //Finished
  return;
  
}



/**
 * Hit event function
 */
f32 onHit(CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitterBlob, u8 customData) {

  //Check if hitter is undead
  if(hitterBlob.hasTag("isUndead")) {
  
    //Tag as besieged
    this.Tag("besieged");
    
    //Set besieged time
    this.set_u32("besiegedTime", getGameTime());

    //Register dealt damage
    this.Damage(damage, hitterBlob);
  
    //Finished, return no damage remaining
    return 0.0f;
    
  }
  
  //Finished, return no damage remaining (ignore)
  return 0.0f;
  
}



/**
 * Change team event function
 */
void onChangeTeam(CBlob@ this, const int oldTeam) {

  //Set changed ownership flag (used for sprite/sound)
  this.Tag("changedOwnership");
  
  //Finished
  return;
  
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
      
        //Obtain a map reference
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
            if(nearbyBlob.getTeamNum() != teamNumber && (nearbyBlob.hasTag("door") || nearbyBlob.hasTag("building") || nearbyBlob.getName() == "ladder")) {
            
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