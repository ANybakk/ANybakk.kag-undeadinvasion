/* 
 * Basic Entity.
 * 
 * Author: ANybakk
 */

namespace Entity {



  const string NAME = "Entity";
  
  
  
  shared class Data {
    
    //Options
    
    Vec2f         oSpriteDefaultToScale     = Vec2f(8.0f, 8.0f);                //Default size for scaling
    bool          oSpriteAutoAnimated       = true;                             //Automatically animated (through configuration file)
    bool          oSpriteAnimateByHealth    = true;                             //Animated based on health (if not automatically animated)
    EventData@[]  oAutoDoOnceEvents;                                            //Array of automatically handled do-once events
    EventData@[]  oAutoDoWhileEvents;                                           //Array of automatically handled do-while events
    
    //EventData (do-once)
    
    EventData     eBlobWasInitialized;
    EventData     eBlobWasDestroyed;
    EventData     eBlobDidCollide;
    EventData     eBlobDidStopCollide;
    EventData     eBlobWasHit;
    EventData     eBlobDidHitBlob;
    EventData     eBlobDidHitMap;
    EventData     eBlobDidCreateInventoryMenu;
    EventData     eBlobDidInventoryAdd;
    EventData     eBlobWasInventoryAdded;
    EventData     eBlobDidInventoryRemove;
    EventData     eBlobWasInventoryRemoved;
    EventData     eBlobChangedQuantity;
    EventData     eBlobChangedHealth;
    EventData     eBlobDidAttach;
    EventData     eBlobDidDetach;
    EventData     eBlobChangedOwnership;
    EventData     eBlobBubbleClicked;
    EventData     eBlobWasStatic;
    EventData     eBlobDidReload;
    EventData     eBlobWasPlayerSet;
    EventData     eSpriteWasInitialized;
    EventData     eSpriteWasScaled;
    EventData     eSpriteWasGibbed;
    
    //EventData (do-while)
    
    EventData     eBlobIsInitialized;
    EventData     eBlobIsDestroyed;
    EventData     eBlobHasInInventory;
    EventData     eBlobIsInInventory;
    EventData     eBlobHasAttachment;
    EventData     eBlobIsStatic;
    EventData     eSpriteIsInitialized;
    
    //Internals
    
    Vec2f         iSpriteSize;                                                  //The current sprite size (x=width, y=height). Should be set in onInit.
    u32           iGameTime;                                                    //The current game time. Should be set in onInit and onTick.
    
  }
  
  
  
  shared class EventData {
  
    string        oSound                    = "";                               //Sound file path/name
    string        oSpriteMode               = "";                               //Sprite mode (animation name)
    int           oSpriteState              = -1;                               //Sprite state (animation frame number)
    f32           oBlobHealth               = -1.0f;                            //Blob health
    int           iTime                     = -1;                               //Time of event
    
    //TODO: opAssign(u32 value) ?
    
  }
  
  
  
  namespace SpriteLayer {
  
  
  
    /**
     * Enumeration for a sprite's layer (z-index)
     */
    enum Layer {
    
      LAYER_ABYSS = -1000,
      LAYER_BACKGROUND = -50,
      LAYER_LADDER = -40,
      LAYER_DEFAULT = 1,
      LAYER_FOREGROUND = 50,
      LAYER_MECHANISM_FOREGROUND = 500
      
    }
    
    
    
  }
  
  
  
  namespace Blob {
  
  
  
    /**
     * Stores a data object
     * 
     * @param   this    a blob pointer.
     * @param   data     a data pointer.
     */
    void storeData(CBlob@ this, Data@ data = null) {

      if(data is null) {
      
        @data = Data();
        
      }
      
      this.set(NAME + "::Data", @data);
      
    }
    
    
    
    /**
     * Retrieves a data object.
     * 
     * @param   this    a blob pointer.
     * @return  data     a pointer to the data (null if none was found).
     */
    Data@ retrieveData(CBlob@ this) {
    
      Data@ data;
      
      this.get(NAME + "::Data", @data);
      
      return data;
      
    }
    
    
    
    /**
     * Returns a vector representing the line between a blob and a position
     * 
     * @param   this            a blob reference.
     * @param   targetPosition  the target position.
     */
    Vec2f getVector(CBlob@ this, Vec2f targetPosition) {
    
      //Finished, return vector
      return (targetPosition - this.getPosition());
      
    }
    
    
    
    /**
     * Returns a vector representing the line between two blobs.
     * 
     * @param   this            a blob reference.
     * @param   targetBlob      the target blob.
     */
    Vec2f getVector(CBlob@ this, CBlob@ targetBlob) {
    
      //Finished, return result from other version of this method
      return getVector(this, targetBlob.getPosition());
      
    }
    
    
    
    /**
     * Returns the distance between a blob and a position.
     * 
     * @param   this            a blob reference.
     * @param   targetPosition  the target position.
     */
    f32 getDistance(CBlob@ this, Vec2f targetPosition) {
    
      //Finished, return distance
      return getVector(this, targetPosition).getLength();
      
    }
    
    
    
    /**
     * Returns the distance between two blobs.
     * 
     * @param   this           a blob reference.
     * @param   targetBlob     the target blob.
     */
    f32 getDistance(CBlob@ this, CBlob@ targetBlob) {
    
      //Finished, return distance
      return getVector(this, targetBlob).getLength();
      
    }
    
    
    
  }
  
  
  
  namespace Sprite {
  
  
  
    /**
     * Sets layer
     * 
     * @param   this      a sprite reference.
     * @param   layer     what layer (Z-index) to put this sprite in.
     */
    void setLayer(CSprite@ this, int layer = SpriteLayer::LAYER_DEFAULT) {

      //Set layer
      this.SetZ(layer);
      
    }
    
    
    
    /**
     * Sets mode (animation name)
     * 
     * @param   this            a sprite reference.
     * @param   animationName   the name of what mode/animation to start.
     */
    void setMode(CSprite@ this, string animationName = "default") {
    
      this.SetAnimation(animationName);
      
    }
    
    
    
    /**
     * Gets the current mode (animation name)
     * 
     * @param   this      a sprite reference.
     * @return            the name of the active mode/animation.
     */
    string getMode(CSprite@ this) {
    
      return this.animation.name;
      
    }
    
    
    
    /**
     * Sets state (animation frame number)
     * 
     * @param   this          a sprite reference.
     * @param   frameNumber   the index of what state/frame to initiate.
     */
    void setState(CSprite@ this, int frameNumber = 0) {
    
      this.animation.frame = frameNumber;
      
    }
    
    
    
    /**
     * Sets state depending on the entity's current health relative to its 
     * initial, full health. It is useful for visualizing deterioration.
     * 
     * @param   this          a sprite reference.
     */
    void setStateAccordingToHealth(CSprite@ this) {
    
      //Obtain blob reference
      CBlob@ blob = this.getBlob();
      
      //Get initial (full) health
      f32 initialHealth = blob.getInitialHealth();
      
      //Get current health
      f32 currentHealth = blob.getHealth();
      
      //Get the number of frames/states for the active animation/mode
      int frameCount = this.animation.getFramesCount();
      
      //Iterate through frames/states (
      for(int i=0; i<frameCount; i++) {
      
        //If current health is within this "segment" (3 frames: >=2/3, >=1/3, >=0/3)
        if(currentHealth >= initialHealth * (frameCount - i - 1) / frameCount) {
        
          //Set state
          setState(this, i);
          
          //Exit loop
          break;
          
        }
        
      }
      
    }
    
    
    
    /**
     * Gets the current state (animation frame number)
     * 
     * @param   this      a sprite reference.
     * @return            the index of the current state/frame.
     */
    int getState(CSprite@ this) {
    
      return this.animation.frame;
      
    }
    
    
    
    /**
     * Scales a sprite
     * 
     * @param   this      a sprite reference.
     * @param   newSize   a vector object representing the desired size (x = width, y = height)
     */
    void scale(CSprite@ this, Vec2f newSize = Vec2f(-1.0f, -1.0f)) {
      
      //Obtain a reference to the blob object
      CBlob@ blob = this.getBlob();
      
      //Retrieve data
      Entity::Data@ data = Entity::Blob::retrieveData(blob);
      
      //Get current size
      Vec2f currentSize = data.iSpriteSize;
      
      //Check if any negative/default size values
      if(newSize.x < 0.0f || newSize.y < 0.0f) {
        
        //Set default new size
        newSize = data.oSpriteDefaultToScale;
        
      }
      
      //Retrieve current offset
      Vec2f offset = this.getOffset();
      
      //Determine scaling factors
      f32 scaleWidth = newSize.x * ((currentSize.x > newSize.x && offset.x >= 0) ? -1.0f : 1.0f) / currentSize.x;
      f32 scaleHeight = newSize.y * ((currentSize.y > newSize.y && offset.y >= 0) ? -1.0f : 1.0f) / currentSize.y;
      
      //Scale
      this.ScaleBy(Vec2f(scaleWidth, scaleHeight));
      
      //Store new size (make sure no negative size values are stored)
      data.iSpriteSize.Set(Maths::Abs(currentSize.x * scaleWidth), Maths::Abs(currentSize.y * scaleHeight));
      
      //Set recently scaled
      data.eSpriteWasScaled.iTime = data.iGameTime;
      
    }
    
    
    
  }
  
  
  
}