/* 
 * Bed blob.
 * 
 * Author: ANybakk
 */

#include "Blob.as";

#include "Help.as" //?



namespace UndeadInvasion {

  namespace BedBlob {
  
  
  
    /**
     * Initializes this entity
     */
    void onInit(CBlob@ this) {
      
      UndeadInvasion::Blob::onInit(this);
      
      setTags(this);
      setCommands(this);
	  
      //Redundant?
      //this.getShape().getConsts().mapCollisions = false;
      
      //Obtain reference to attachment point
      AttachmentPoint@ bed = this.getAttachments().getAttachmentPointByName("BED");
      
      //If valid reference
      if(bed !is null) {
      
        //Disable relevant key presses
        bed.SetKeysToTake(key_left | key_right | key_up | key_down | key_action1 | key_action2 | key_action3 | key_pickup | key_inventory);
        
        //Disable mouse
        bed.SetMouseTaken(true);
        
      }
      
      this.getCurrentScript().runFlags |= Script::tick_hasattached;
      
      //this.getCurrentScript().tickFrequency = 179;
      
    }
  
    
    
    /**
     * Sets various tags for this entity type.
     * 
     * @param   this            a blob reference.
     */
    void setTags(CBlob@ this) {
    
      this.Tag("isBedBlob");
      this.Tag("dead head"); //?
      
    }
  
    
    
    /**
     * Sets various commands for this entity type.
     * 
     * @param   this            a blob reference.
     */
    void setCommands(CBlob@ this) {
    
      this.addCommandID("rest");
      AddIconToken("$rest$", "InteractionIcons.png", Vec2f(32, 32), 29); //Icon number 30
      
    }
    
    
    
    /**
     * Tick event function
     */
    void onTick(CBlob@ this) {
    
      //Obtain a reference to the attachment point "BED"
      AttachmentPoint@ attachmentPoint = this.getAttachments().getAttachmentPointByName("BED");
      
      //Continue, if attachment point valid
      if(attachmentPoint !is null) {
      
        //Obtain a reference to any blob occupying the attachment point
        CBlob@ occupyingBlob = attachmentPoint.getOccupied();
        
        //Continue, if occupying blob valid
        if(occupyingBlob !is null) {
        
          //Continue, if attachment up key was pressed
          if(attachmentPoint.isKeyJustPressed(key_up)) {
          
            //Detatch
            occupyingBlob.server_DetachFrom(this);
            
          }
          
          //Otherwise
          else {
          
            //Recall attached time
            u16 attachedTime = this.get_u16("attachedTime");
            
            //Determine time elapsed
            u16 elapsedTime = getGameTime()- attachedTime;
            
            //Proceed if time to heal; one whole day cycle to completely heal
            //evaluate with whole number division of elapsed time with:
            //  number of ticks for a whole day, divided by:
            //    number of quarter hearts (Builder has health 1.5, knight 2.0, archer 1.0)
            if(elapsedTime % ((getRules().daycycle_speed * 60 * getTicksASecond()) / (2 * 4 * occupyingBlob.getInitialHealth())) == 0) {
            
              //Check if damaged
              if (UndeadInvasion::Blob::isDamaged(occupyingBlob)) {
              
                //Check if current player
                if (occupyingBlob.isMyPlayer()) {
                
                  //Play heal sound
                  Sound::Play("Heart.ogg", occupyingBlob.getPosition());
                  
                }
                
                //Heal
                occupyingBlob.server_Heal(0.25f);
                
                //Check if fully healed
                if(!UndeadInvasion::Blob::isDamaged(occupyingBlob)) {
                
                  //Detach
                  occupyingBlob.server_DetachFrom(this);
                  
                }

              }
              
              //Otherwise (not damaged)
              else {
              
                //Detach
                occupyingBlob.server_DetachFrom(this);
                
              }
              
            }
            
          }
          
        }
        
      }
      
    }
    
    
    
    /**
     * Command event function
     */
    void onCommand(CBlob@ this, u8 cmd, CBitStream @params) {
      
      //If rest
      if(cmd == this.getCommandID("rest")) {
      
        //Attempt to read caller ID
        u16 caller_id;
        if(!params.saferead_netid(caller_id)) {
          return;
        }
        
        //Obtain reference to caller blob
        CBlob@ callerBlob = getBlobByNetworkID(caller_id);
        
        //Continue, if valid reference
        if(callerBlob !is null) {
        
          //Stop if fully healed
          if(!UndeadInvasion::Blob::isDamaged(callerBlob)) { return; }
          
          //Obtain reference to attachment point
          AttachmentPoint@ bed = this.getAttachments().getAttachmentPointByName("BED");
          
          //Continue, if valid reference
          if(bed !is null) {
          
            //Obtain reference to any carried blob
            CBlob@ carriedBlob = callerBlob.getCarriedBlob();
            
            //Continue, if valid reference
            if(carriedBlob !is null) {
            
              //Attempt to put carried blob into inventory, and continue if failed
              if(!callerBlob.server_PutInInventory(carriedBlob)) {
              
                //Detach carried blob
                carriedBlob.server_DetachFrom(callerBlob);
                
              }
              
            }
            
            //Attach called blob
            this.server_AttachTo(callerBlob, "BED");
            
          }
          
        }
        
      }
      
    }
    
    
    
    /**
     * 
     */
    void GetButtonsFor(CBlob@ this, CBlob@ caller) {
    
      //Create parameter bit stream
      CBitStream params;
      
      //Write caller ID to stream
      params.write_u16(caller.getNetworkID());
      
      //Create a button that sends the rest command
      caller.CreateGenericButton("$rest$", Vec2f(0, 0), this, this.getCommandID("rest"), "Rest", params);
      
    }
    
    
    
    /**
     * Attach event function
     */
    void onAttach(CBlob@ this, CBlob@ attached, AttachmentPoint@ attachedPoint) {
    
      //TODO: This is also called when chosen in the build menu, in the hands of the player
      
      //Stop, if not bed
      if(attachedPoint.name != "BED") { return; }
      
      this.set_bool("hasAttached", true);
      this.set_bool("wasAttached", true);
      this.set_u16("attachedTime", getGameTime());
      this.set_u16("attachedID", attached.getNetworkID());
      
      //Disable collision
      attached.getShape().getConsts().collidable = false;
      
      //Set facing direction
      attached.SetFacingLeft(true);
      
      //Add a script that acts on hit
      attached.AddScript("WakeOnHit.as");
      
    }
    
    
    
    /**
     * Detach event function
     */
    void onDetach(CBlob@ this, CBlob@ detached, AttachmentPoint@ attachedPoint) {
    
      this.set_bool("hasAttached", false);
      this.set_bool("wasDetached", true);
      
      //Enable collision
      detached.getShape().getConsts().collidable = true;
      
      //Add a force (?)
      detached.AddForce(Vec2f(0, -20));
      
      //Remove hit script
      detached.RemoveScript("WakeOnHit.as");
      
    }
    
    
    
  }
  
}