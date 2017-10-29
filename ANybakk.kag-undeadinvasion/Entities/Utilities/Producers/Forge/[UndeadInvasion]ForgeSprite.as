/* 
 * Forge sprite.
 * 
 * Author: ANybakk
 */

#include "[UndeadInvasion]ProducerSprite.as";
#include "[UndeadInvasion]ForgeFuelType.as";



namespace UndeadInvasion {

  namespace ForgeSprite {
  
  
  
    void onInit(CSprite@ this) {
    
      UndeadInvasion::ProducerSprite::onInit(this);
      
      this.SetAnimation("fuel");
      this.animation.frame = 0;
      
      //Get fire animation
      Animation@ fireAnimation = this.getAnimation("fire");
      
      //Add fire layer
      CSpriteLayer@ fireLayer = this.addSpriteLayer("fire", this.getFilename(), this.getFrameWidth(), this.getFrameHeight());
      
      //If valid reference
      if(fireLayer !is null) {
      
        //Set animation
        fireLayer.SetAnimation(fireAnimation);
        
        //Set invisible
        fireLayer.SetVisible(false);
        
        //Disable lighting
        fireLayer.SetLighting(true);
        
      }
      
      //Set up fire sound file
      this.SetEmitSound("CampfireSound.ogg");
      
      //Pause fire sound
      this.SetEmitSoundPaused(true);
      
      //Set fire sound volume
      //this.SetEmitSoundVolume(0.5f);
      
    } //End function
    
    
    
    void onTick(CSprite@ this) {
    
      CBlob@ blob = this.getBlob();
      
      //Set frame depending on fuel
      this.animation.frame = blob.get_u8("fuelState");
      
      //Obtain reference to fire layer
      CSpriteLayer@ fireLayer = this.getSpriteLayer("fire");
      
      //Check if producing anything
      if(blob.get_string("currentProductName") != "") {
        
        //Check if layer is valid and not currently visible
        if(fireLayer !is null && !fireLayer.isVisible()) {
        
          //Make visible
          fireLayer.SetVisible(true);
          
          //Un-pause fire sound
          this.SetEmitSoundPaused(false);
          
        }
        
      }
      
      //Otherwise, not producing anything
      else {
        
        //Make fire layer invisible
        fireLayer.SetVisible(false);
        
        //Pause fire sound
        this.SetEmitSoundPaused(true);
        
      }
      
    } //End function
    
    
    
  } //End namespace
   
} //End namespace