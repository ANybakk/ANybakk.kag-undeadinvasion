
#include "[UndeadInvasion]SurvivorCampSpriteMode.as";



/**
 * Initialization event function
 */
void onInit(CSprite@ this) {

  //Retrieve team number
  int team = this.getBlob().getTeamNum();
  
  //Check if ordinary team
  if (team >= 0 && team <= 10) {
  
    //Set mode to active
    this.animation.frame = SurvivorCampSpriteMode::MODE_DEFAULT;
    
  }
  
}



/**
 * Rendering event function
 */
void onRender(CSprite@ this) {

  //Check if recording video
  if (g_videorecording) {
  
    //Stop
    return;
    
  }

  //Obtain a reference to the blob object
  CBlob@ blob = this.getBlob();
  
  //Check if under attack
  if(blob.hasTag("besieged")) {
  
    CMap@ map = blob.getMap();
    
    //Determine the position directly above
    Vec2f positionAbove = getDriver().getScreenPosFromWorldPos(blob.getPosition() + Vec2f(0.0f, -blob.getHeight()));
    
    //Draw alert icon
    GUI::DrawIconByName("$ALERT$", Vec2f(positionAbove.x - 4.0f * map.tilesize, positionAbove.y - 30.0f));
    
    //Set default mini-map icon in second position (alert), size 16x16
    //TODO: Enough to make this call only once?
    blob.SetMinimapVars("GUI/Minimap/MinimapIcons.png", 1, Vec2f(16, 16));
    
  } else {
  
    //Unset mini-map icon
    blob.UnsetMinimapVars();
  
  }
  
  //Check if recently changed ownership
  if(blob.hasTag("changedOwnership")) {
  
    //Play a fanfare
    Sound::Play("/VehicleCapture");
  
    //Set mode to active
    this.animation.frame = SurvivorCampSpriteMode::MODE_ACTIVE;
    
    //Disable flag
    blob.Untag("changedOwnership");
    
  }
  
  //Finished
  
}