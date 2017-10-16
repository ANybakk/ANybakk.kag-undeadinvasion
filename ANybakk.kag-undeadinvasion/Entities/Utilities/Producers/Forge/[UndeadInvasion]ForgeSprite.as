/* 
 * Forge sprite.
 * 
 * Author: ANybakk
 */

#include "[UndeadInvasion]ProducerSprite.as";



namespace UndeadInvasion {

  namespace ForgeSprite {
  
  
  
    void onInit(CSprite@ this) {
    
      UndeadInvasion::ProducerSprite::onInit(this);
      
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
      
    }
    
    
    
    void onTick(CSprite@ this) {
    
      CBlob@ blob = this.getBlob();
      
      //Check if fuel present
      if(blob.get_bool("fuelled")) {
      
        this.animation.frame = 1;
        
      }
      
      //Otherwise, no fuel present
      else {
      
        this.animation.frame = 0;
        
      }
      
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
      
    }
    
    
    
  }
   
}