/* 
 * Object blob
 * 
 * Author: ANybakk
 */

#include "Blob.as";

#include "Hitters.as";



namespace UndeadInvasion {

  namespace ObjectBlob {
  
  
  
    /**
     * Initializes this entity
     */
    void onInit(CBlob@ this) {
      
      UndeadInvasion::Blob::onInit(this);
      
      setTags(this);
      setCommands(this);
      setHarvestMaterials(this);
      
      //Set team
      this.server_setTeamNum(-1);
      
    }
  
    
    
    /**
     * Sets various tags for this entity type. Inheriting types should call this.
     * 
     * @param   this            a blob reference.
     */
    void setTags(CBlob@ this) {
    
      this.Tag("isObjectBlob");
      
    }
    
    
    
    /**
     * Sets various commands for this entity type.
     * 
     * @param   this            a blob reference.
     */
    void setCommands(CBlob@ this) {
    
      //this.addCommandID("commandName");
      //AddIconToken("$commandName$", "InteractionIcons.png", Vec2f(32, 32), 0); //Icon number 1
      
    }
    
    
    
    /**
     * Sets what materials are returned when harvesting
     */
    void setHarvestMaterials(CBlob@ this) {
    
      //Replace with derivative of BlobBuildBlock
      //this.set("harvest", BlobBuildBlock().mHarvestMaterials);
      
    }
    
    
    
    bool doesCollideWithBlob(CBlob@ this, CBlob@ blob) {
    
      //Always collide
      return true;
      
    }
    
    
    
    void onDetach(CBlob@ this, CBlob@ detached, AttachmentPoint@ attachedPoint) {
    
      //Set player
      this.SetDamageOwnerPlayer(detached.getPlayer());
      
    }
    
    
    
    void onCollision(CBlob@ this, CBlob@ blob, bool solid) {
    
      //Stop, if no valid reference
      if(blob is null) {
        return;
      }
      
      //Calculate damage
      const f32 damage = this.getShape().vellen * ObjectVariables::DAMAGE_DEAL_MODIFIER;
      
      //Continue if damage beyound treshold
      if(damage > ObjectVariables::DAMAGE_DEAL_TRESHOLD) {
      
        //Deal damage
        this.server_Hit(blob, this.getPosition(), this.getVelocity(), damage, Hitters::flying, false);
        
      }
      
    }
    
    
    
  }
  
}