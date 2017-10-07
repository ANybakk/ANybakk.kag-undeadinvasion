/* 
 * Producer sprite.
 * 
 * Author: ANybakk
 */



namespace UndeadInvasion {

  namespace ProducerSprite {
  
  
  
    void onInit(CSprite@ this) {
    
      //Put in background
      this.SetZ(-50);
      
    }
    
    
    
    void onTick(CSprite@ this) {
      
    }
    
    
    
    void onRender(CSprite@ this) {
    
      //Obtain a reference to the blob object
      CBlob@ blob = this.getBlob();
    
      //Check if producing something
      if(blob.get_string("currentProductName") != "") {
        
        //Determine how much time has passed
        u16 currentProductionTime = getGameTime() - blob.get_u16("producingStartTime");
        
        //Determine how much time from start to finish
        u16 fullProductionTime = blob.get_u16("producingFinishTime") - blob.get_u16("producingStartTime");
        
        //Continue only if not yet finished
        if(currentProductionTime <= fullProductionTime) {
          
          //Calculate positions
          Vec2f barTopLeftPosition = blob.getPosition() + Vec2f(-ProducerVariables::PROGRESS_BAR_SIZE.x/2, blob.getHeight() / 2 - 1.0f - ProducerVariables::PROGRESS_BAR_SIZE.y);
          Vec2f barBottomRightPosition = blob.getPosition() + Vec2f(ProducerVariables::PROGRESS_BAR_SIZE.x/2, blob.getHeight() / 2 - 1.0f);
          
          //Draw progress bar
          GUI::DrawProgressBar(
              getDriver().getScreenPosFromWorldPos(barTopLeftPosition)
              , getDriver().getScreenPosFromWorldPos(barBottomRightPosition)
              , (0.0f + currentProductionTime) / (0.0f + fullProductionTime)
            );
          
        }
        
      }
      
    }
    
    
    
  }
   
}