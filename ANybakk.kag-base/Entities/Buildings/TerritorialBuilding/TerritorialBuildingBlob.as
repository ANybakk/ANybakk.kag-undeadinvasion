/* 
 * TerritorialBuilding blob script
 * 
 * Author: ANybakk
 */

//#include "Entity.as"
#include "TerritorialBuilding.as"
#include "ClassSelectMenu.as"
#include "StandardRespawnCommand.as"
#include "Help.as"



//Called on initialization.
void onInit(CBlob@ this) {
  
  //Set tick frequency to 30
  //this.getCurrentScript().tickFrequency = 30;

  //Default data
  
  TerritorialBuilding::Data data();
  TerritorialBuilding::Blob::storeData(this, @data);
  
  //Entity data modifications
  
  //Entity::Data@ entityData = Entity::Blob::retrieveData(this);
  //entityData.oAutoDoOnceEvents.push_back(@(data.eBlobWasOverwhelmed));        //Example of using in conjunction with Entity's auto events
  //entityData.oAutoDoWhileEvents.push_back(@(data.eBlobIsBesieged));
  
  //Initializations
  
  this.Tag("isTerritorialBuilding");
  
  //Initialize icons and add class data objects to blob (StandardRespawnCommand.as)
  InitClasses(this);
  
  //Initialize "class menu" command (StandardRespawnCommand.as)
  InitRespawnCommand(this);
  
  //Set to snap icons on mini-map edge
  this.SetMinimapOutsideBehaviour(CBlob::minimap_snap);
  
  //Set minimap to always be rendered
  this.SetMinimapRenderAlways(true);
  
  //Disable water
  this.getShape().getConsts().waterPasses = false;

  //Set help text (?)
  SetHelp(this, "help use", "", "Change class    $KEY_E$", "", 5);
  
  //Set inventory button position
  this.inventoryButtonPos = Vec2f(24, -14);
  
  //Store position for travel button (TunnelTravel.as)
  this.set_Vec2f("travel button pos", Vec2f(-12, 7));

  //Set an extended no-build zone for floor tiles below
  this.set_Vec2f("nobuild extend", Vec2f(0.0f, 0.0f + this.getMap().tilesize));
  
  //Tag blob so that inventory is stored on class change (StandardRespawnCommand.as)
  this.Tag("change class store inventory");
  
}



//Called on every tick.
void onTick(CBlob@ this) {

  //Retrieve data
  TerritorialBuilding::Data@ data = TerritorialBuilding::Blob::retrieveData(this);
  
  //Check if under siege
  if(data.eBlobIsBesieged.iTime >= 0) {
    
    //Determine for how long besiege alert have been active
    u32 besiegedBesiegedAlertTime = getGameTime() - data.eBlobIsBesieged.iTime;
    
    //Check if alert period is over
    if(besiegedBesiegedAlertTime > data.oBesiegedAlertTimeout * getTicksASecond()) {
    
      //Unset besieged
      data.eBlobIsBesieged.iTime = -1;
    
    }
    
  }
  
}



//
void onCommand(CBlob@ this, u8 cmd, CBitStream @params) {

  //Call function for standard commands (StandardRespawnCommand.as)
  onRespawnCommand(this, cmd, params);
  
}



//
bool isInventoryAccessible(CBlob@ this, CBlob@ forBlob) {

  //Return true if on same team and overlapping
  return forBlob.getTeamNum() == this.getTeamNum() && forBlob.isOverlapping(this);
  
}