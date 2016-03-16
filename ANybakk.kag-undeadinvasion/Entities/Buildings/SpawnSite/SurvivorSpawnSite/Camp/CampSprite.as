/* 
 * Camp sprite script
 * 
 * Author: ANybakk
 */

//#include "Camp.as"
#include "TerritorialBuilding.as"



//
void onRender(CSprite@ this) {

  //Check if recording video
  if (g_videorecording) {
  
    //Stop
    return;
    
  }

  //Obtain blob reference
  CBlob@ blob = this.getBlob();
  
  //Retrieve data
  TerritorialBuilding::Data@ territorialBuildingData = TerritorialBuilding::Blob::retrieveData(blob);
  
  //Check if besieged
  if(territorialBuildingData.eBlobIsBesieged.iTime >= 0) {
  
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
  
}