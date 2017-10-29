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
    
      CBlob@ blob = this.getBlob();
    
      //Check if producing something
      if(blob.get_string("currentProductName") != "") {
        
        //Determine how much time has passed
        u16 currentProductionTime = getGameTime() - blob.get_u16("producingStartTime");
        
        //Determine how much time from start to finish
        u16 fullProductionTime = blob.get_u16("producingFinishTime") - blob.get_u16("producingStartTime");
        
        //Continue only if not yet finished
        if(currentProductionTime <= fullProductionTime) {
        
          //Calculate left and right positions
          Vec2f barLeftPosition = getDriver().getScreenPosFromWorldPos(blob.getPosition() + Vec2f(-ProducerVariables::PROGRESS_BAR_SIZE.x/2, blob.getHeight()/2 + 2.0f));
          Vec2f barRightPosition = getDriver().getScreenPosFromWorldPos(blob.getPosition() + Vec2f(ProducerVariables::PROGRESS_BAR_SIZE.x/2, blob.getHeight()/2 + 2.0f));
          
          //Draw progress bar
          GUI::DrawProgressBar(
                barLeftPosition
              , barRightPosition + Vec2f(0.0f, ProducerVariables::PROGRESS_BAR_SIZE.y)
              , (0.0f + currentProductionTime) / (0.0f + fullProductionTime)
            );
          
        }
        
      }
      
    }
    
    
    
  }
   
}