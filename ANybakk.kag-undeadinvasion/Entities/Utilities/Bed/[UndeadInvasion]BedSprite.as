/* 
 * Bed sprite.
 * 
 * Author: ANybakk
 */



namespace UndeadInvasion {

  namespace BedSprite {
  
  
  
    void onInit(CSprite@ this) {
    
      //Put in background
      this.SetZ(-50);
      
      //Set first frame
      this.SetFrame(0);
      
      //Add snore bubble layer
      //CSpriteLayer@ snoreBubbleLayer = this.addSpriteLayer("zzz", 8, 8);
      CSpriteLayer@ snoreBubbleLayer = this.addSpriteLayer("zzz", "[UndeadInvasion]BedSnoreBubble.png", 8, 8);
      
      //If valid reference
      if(snoreBubbleLayer !is null) {
      
        //Add default animation
        //snoreBubbleLayer.addAnimation("default", 15, true); //(name, time, loop)
        snoreBubbleLayer.addAnimation("default", 13, true); //(name, time, loop)
        
        //Create frame array
        //int[] frames = {6, 7, 14, 15};
        int[] frames = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13};
        
        //Add frames
        snoreBubbleLayer.animation.AddFrames(frames);
        
        //Set offset (?)
        snoreBubbleLayer.SetOffset(Vec2f(-7 * (this.getBlob().isFacingLeft() ? -1.0f : 1.0f),-7));
        
        //Set invisible
        snoreBubbleLayer.SetVisible(false);
        
        //Disable lighting
        snoreBubbleLayer.SetLighting(false);
        
        //Set HUD (?)
        snoreBubbleLayer.SetHUD(true);
        
      }
      
      //Set up snoring sound file
      this.SetEmitSound("MigrantSleep.ogg");
      
      //Pause snoring sound
      this.SetEmitSoundPaused(true);
      
      //Set snoring sound volume
      this.SetEmitSoundVolume(0.5f);
      
    }
    
    
    
    void onTick(CSprite@ this) {
    
      //Obtain a reference to the blob object
      CBlob@ blob = this.getBlob();
    
      //Check if recently attached
      if(blob.get_bool("wasAttached")) {
      
        //Reset flag
        blob.set_bool("wasAttached", false);
        
        //Obtain a reference to any blob occupying the attachment point
        CBlob@ occupyingBlob = getBlobByNetworkID(blob.get_u16("attachedID"));
        
        //Stop, if reference invalid
        if(occupyingBlob is null) { return; }
        
        //Obtain reference to sprite
        CSprite@ occupyingSprite = occupyingBlob.getSprite();
        
        //Stop, if reference invalid
        if(occupyingSprite is null) { return; }
        
        //Hide
        occupyingSprite.SetVisible(false);
        
        //Play attach sound
        occupyingSprite.PlaySound("GetInVehicle.ogg");
        
        //Obtain reference to head layer
        CSpriteLayer@ occupyingHeadLayer = occupyingSprite.getSpriteLayer("head");
        
        //Stop, if reference invalid
        if(occupyingHeadLayer is null) { return; }
        
        //Obtain reference to head animation
        Animation@ occupyingHeadAnimation = occupyingHeadLayer.getAnimation("default");
        
        //Stop if reference invalid
        if(occupyingHeadAnimation is null) { return; }
        
        //Create layer for head, matching occupant
        CSpriteLayer@ headLayer = this.addSpriteLayer("bed head", occupyingHeadLayer.getFilename(), 16, 16, occupyingBlob.getTeamNum(), occupyingBlob.getSkinNum());
        
        //Stop if reference invalid
        if(headLayer is null) { return; }
        
        //Create default animation
        Animation@ headAnimation = headLayer.addAnimation("default", 0, false);
        
        //Stop if reference invalid
        if(headAnimation is null) { return; }
        
        //Add frame based on occupant
        headAnimation.AddFrame(occupyingHeadAnimation.getFrame(2));
        
        //Set animation
        headLayer.SetAnimation(headAnimation);
        
        //Rotate
        headLayer.RotateBy(80, Vec2f_zero);
        
        //Set offset
        headLayer.SetOffset(Vec2f(8, 1));
        
        //Set facing direction
        headLayer.SetFacingLeft(true);
        
        //Set visible
        headLayer.SetVisible(true);
        
        //Put on top
        headLayer.SetRelativeZ(2);
        
        //Obtain reference to snore bubble layer
        CSpriteLayer@ snoreBubbleLayer = this.getSpriteLayer("zzz");
        
        //Continue, if valid reference
        if(snoreBubbleLayer !is null) {
        
          //Set first frame
          snoreBubbleLayer.SetFrameIndex(0);
          
          //Set visible
          snoreBubbleLayer.SetVisible(true);
          
        }
        
        //Unpause snore sound
        this.SetEmitSoundPaused(false);
        
        //Rewind snore sound
        this.RewindEmitSound();
        
      }
    
      //Check if recently detached
      if(blob.get_bool("wasDetached")) {
      
        //Reset flag
        blob.set_bool("wasDetached", false);
        
        //Obtain a reference to any blob occupying the attachment point
        CBlob@ occupyingBlob = getBlobByNetworkID(blob.get_u16("attachedID"));
        
        //Stop, if reference invalid
        if(occupyingBlob is null) { return; }
        
        //Obtain reference to sprite
        CSprite@ occupyingSprite = occupyingBlob.getSprite();
        
        //Stop, if reference invalid
        if(occupyingSprite is null) { return; }
        
        //Set visible
        occupyingSprite.SetVisible(true);
        
        //Obtain reference to snore bubble layer
        CSpriteLayer@ snoreBubbleLayer = this.getSpriteLayer("zzz");
        
        //Stop, if reference invalid
        if(snoreBubbleLayer is null) { return; }
        
        //Set frame
        snoreBubbleLayer.SetFrameIndex(0);
        
        //Set invisible
        snoreBubbleLayer.SetVisible(false);
        
        //Obtain reference to head layer
        CSpriteLayer@ headLayer = this.getSpriteLayer("bed head");
        
        //Stop, if reference invalid
        if(headLayer is null) { return; }
        
        //Remove layer
        this.RemoveSpriteLayer("bed head");
        
        //Pause snore sound
        this.SetEmitSoundPaused(true);
        
      }
      
    }
    
    
    
  }
   
}