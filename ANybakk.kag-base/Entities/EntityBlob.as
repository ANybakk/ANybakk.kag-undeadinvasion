/* 
 * Entity blob script
 * 
 * Author: ANybakk
 */

#include "Entity.as"



//Called on initialization.
void onInit(CBlob@ this) {

  //Default data
  
  Entity::Data data();
  
  //Set time
  data.iGameTime = getGameTime();
  
  //Set events
  data.eBlobWasInitialized.iTime = data.iGameTime;
  data.eBlobIsInitialized.iTime = data.iGameTime;
  
  Entity::Blob::storeData(this, @data);
  
  //Initialization
  
  this.Tag("isEntity");
  
}



//Called on every tick.
void onTick(CBlob@ this) {
  
  //Retrieve data
  Entity::Data@ data = Entity::Blob::retrieveData(this);
  
  //Store game time
  data.iGameTime = getGameTime();
  
  //Obtain references to other objects
  CSprite@ sprite = this.getSprite();
  
  //Create EventData handle
  Entity::EventData@ eventData;
  
  //Iterate through all auto do-once events
  for(uint i=0; i<data.oAutoDoOnceEvents.length; i++) {
  
    //Keep a reference to event
    eventData = data.oAutoDoOnceEvents[i];
    
    //Check if active event
    if(eventData.iTime >= 0) {
    
      //Check if valid sprite object
      if(sprite !is null) {
    
        //Check if sound is set
        if(eventData.oSound != "") {
        
          //Play sound
          Sound::Play(eventData.oSound);
        
        }
        
        //Check if sprite mode is set
        if(eventData.oSpriteMode != "") {
        
          //Change mode
          Entity::Sprite::setMode(sprite, eventData.oSpriteMode);
          
        }
        
        //Check if sprite state is set
        if(eventData.oSpriteState >= 0) {
        
          //Change state
          Entity::Sprite::setState(sprite, eventData.oSpriteState);
          
        }
        
      }
      
      //Check if blob health is set
      if(eventData.oBlobHealth >= 0) {
      
        //Change health
        blob.server_SetHealth(eventData.oBlobHealth);
        
      }
      
      //Unset
      eventData.iTime = -1;
      
    }
    
  }
  
}



//Called on death/destruction.
void onDie(CBlob@ this) {
  
  //Retrieve data
  Entity::Data@ data = Entity::Blob::retrieveData(this);
  
  //Set event
  data.eBlobWasDestroyed.iTime = data.iGameTime;
  data.eBlobIsDestroyed.iTime = data.iGameTime;
  
}



//Called on collision.
void onCollision(CBlob@ this, CBlob@ blob, bool solid) {
  
  //Retrieve data
  Entity::Data@ data = Entity::Blob::retrieveData(this);
  
  //Set event
  data.eBlobDidCollide.iTime = data.iGameTime;
  
}



//Called on collision.
void onCollision(CBlob@ this, CBlob@ blob, bool solid, Vec2f normal) {
  
  //Retrieve data
  Entity::Data@ data = Entity::Blob::retrieveData(this);
  
  //Set event
  data.eBlobDidCollide.iTime = data.iGameTime;
  
}



//Called on collision.
void onCollision(CBlob@ this, CBlob@ blob, bool solid, Vec2f normal, Vec2f point1) {
  
  //Retrieve data
  Entity::Data@ data = Entity::Blob::retrieveData(this);
  
  //Set event
  data.eBlobDidCollide.iTime = data.iGameTime;
  
}



//Called on collision.
void onCollision(CBlob@ this, CBlob@ blob, bool solid, Vec2f normal, Vec2f point1, Vec2f point2) {
  
  //Retrieve data
  Entity::Data@ data = Entity::Blob::retrieveData(this);
  
  //Set event
  data.eBlobDidCollide.iTime = data.iGameTime;
  
}



//
void onEndCollision(CBlob@ this, CBlob@ blob) {
  
  //Retrieve data
  Entity::Data@ data = Entity::Blob::retrieveData(this);
  
  //Set event
  data.eBlobDidStopCollide.iTime = data.iGameTime;
  
}



//Called on every hit.
f32 onHit(CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitterBlob, u8 customData) {
  
  //Retrieve data
  Entity::Data@ data = Entity::Blob::retrieveData(this);
  
  //Set event
  data.eBlobWasHit.iTime = data.iGameTime;
  
  return damage;
  
}



//
void onHitBlob(CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitBlob, u8 customData) {
  
  //Retrieve data
  Entity::Data@ data = Entity::Blob::retrieveData(this);
  
  //Set event
  data.eBlobDidHitBlob.iTime = data.iGameTime;
  
}



//
void onHitMap(CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, u8 customData) {
  
  //Retrieve data
  Entity::Data@ data = Entity::Blob::retrieveData(this);
  
  //Set event
  data.eBlobDidHitMap.iTime = data.iGameTime;
  
}



//
void onCreateInventoryMenu(CBlob@ this, CBlob@ forBlob, CGridMenu @gridmenu) {
  
  //Retrieve data
  Entity::Data@ data = Entity::Blob::retrieveData(this);
  
  //Set event
  data.eBlobDidCreateInventoryMenu.iTime = data.iGameTime;
  
}



//
void onAddToInventory(CBlob@ this, CBlob@ blob) {
  
  //Retrieve data
  Entity::Data@ data = Entity::Blob::retrieveData(this);
  
  //Set event
  data.eBlobDidInventoryAdd.iTime = data.iGameTime;
  
  //Check if event not set
  if(data.eBlobHasInInventory.iTime < 0) {
  
    //Set event
    data.eBlobHasInInventory.iTime = data.iGameTime;
    
  }
  
}



//
void onThisAddToInventory(CBlob@ this, CBlob@ inventoryBlob) {
  
  //Retrieve data
  Entity::Data@ data = Entity::Blob::retrieveData(this);
  
  //Set event
  data.eBlobWasInventoryAdded.iTime = data.iGameTime;
  
  //Check if event not set
  if(data.eBlobIsInInventory.iTime < 0) {
  
    //Set event
    data.eBlobIsInInventory.iTime = data.iGameTime;
    
  }
  
}



//
void onRemoveFromInventory(CBlob@ this, CBlob@ blob) {
  
  //Retrieve data
  Entity::Data@ data = Entity::Blob::retrieveData(this);
  
  //Set event
  data.eBlobDidInventoryRemove.iTime = data.iGameTime;
  
  //Obtain inventory object reference
  CInventory@ inventory = this.getInventory();
  
  //Check if inventory is empty
  //TODO: This item might still be counted?
  if(inventory.getItemsCount() == 0) {
  
    //Unset event
    data.eBlobHasInInventory.iTime = -1;
    
  }
  
}



//
void onThisRemoveFromInventory(CBlob@ this, CBlob@ inventoryBlob) {
  
  //Retrieve data
  Entity::Data@ data = Entity::Blob::retrieveData(this);
  
  //Set event
  data.eBlobWasInventoryRemoved.iTime = data.iGameTime;
  data.eBlobIsInInventory.iTime = -1;
  
}



//
void onQuantityChange(CBlob@ this, int oldQuantity) {
  
  //Retrieve data
  Entity::Data@ data = Entity::Blob::retrieveData(this);
  
  //Set event
  data.eBlobChangedQuantity.iTime = data.iGameTime;
  
}



//
void onHealthChange(CBlob@ this, f32 oldHealth) {
  
  //Retrieve data
  Entity::Data@ data = Entity::Blob::retrieveData(this);
  
  //Set event
  data.eBlobChangedHealth.iTime = data.iGameTime;
  
}



//
void onAttach(CBlob@ this, CBlob@ attached, AttachmentPoint @attachedPoint) {
  
  //Retrieve data
  Entity::Data@ data = Entity::Blob::retrieveData(this);
  
  //Set event
  data.eBlobDidAttach.iTime = data.iGameTime;
  
  //Check if event not set
  if(data.eBlobHasAttachment.iTime < 0) {
  
    //Set event
    data.eBlobHasAttachment.iTime = data.iGameTime;
    
  }
  
}



//
void onDetach(CBlob@ this, CBlob@ detached, AttachmentPoint@ attachedPoint) {
  
  //Retrieve data
  Entity::Data@ data = Entity::Blob::retrieveData(this);
  
  //Set event
  data.eBlobDidDetach.iTime = data.iGameTime;
  
  //Check if no attachments
  //TODO: This attachment might still be counted?
  if(this.getAttachmentPointCount() == 0) {
  
    //Unset event
    data.eBlobHasAttachment.iTime = -1;
    
  }
  
}



void onChangeTeam(CBlob@ this, const int oldTeam) {
  
  //Retrieve data
  Entity::Data@ data = Entity::Blob::retrieveData(this);
  
  //Set event
  data.eBlobChangedOwnership.iTime = data.iGameTime;
  
}



//
void onClickedBubble(CBlob@ this, int index) {
  
  //Retrieve data
  Entity::Data@ data = Entity::Blob::retrieveData(this);
  
  //Set event
  data.eBlobBubbleClicked.iTime = data.iGameTime;
  
}



//
void onSetStatic(CBlob@ this, const bool isStatic) {
  
  //Retrieve data
  Entity::Data@ data = Entity::Blob::retrieveData(this);
  
  //Set events
  data.eBlobWasStatic.iTime = data.iGameTime;
  
  //Check if static
  if(isStatic) {
  
    //Set event
    data.eBlobIsStatic.iTime = data.iGameTime;
    
  }
  
}



//
void onReload(CBlob@ this) {
  
  //Retrieve data
  Entity::Data@ data = Entity::Blob::retrieveData(this);
  
  //Set event
  data.eBlobDidReload.iTime = data.iGameTime;
  
}



//
void onSetPlayer(CBlob@ this, CPlayer@ player) {
  
  //Retrieve data
  Entity::Data@ data = Entity::Blob::retrieveData(this);
  
  //Set event
  data.eBlobWasPlayerSet.iTime = data.iGameTime;
  
}