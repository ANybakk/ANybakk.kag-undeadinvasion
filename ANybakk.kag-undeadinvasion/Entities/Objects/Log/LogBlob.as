/* 
 * Log blob
 * 
 * Author: ANybakk
 */

#include "ObjectBlob.as";

#include "LogBuildBlock.as";



namespace UndeadInvasion {

  namespace LogBlob {
  
  
  
    /**
     * Initializes this entity
     */
    void onInit(CBlob@ this) {
      
      UndeadInvasion::ObjectBlob::onInit(this);
      
      setTags(this);
      setCommands(this);
      setHarvestMaterials(this);
      
      //Set decay
      this.server_SetTimeToDie(240 + XORRandom(60));
      
    }
  
    
    
    /**
     * Sets various tags for this entity type. Inheriting types should call this.
     * 
     * @param   this            a blob reference.
     */
    void setTags(CBlob@ this) {
    
      this.Tag("isLogBlob");
      
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
    
      this.set("harvest", LogBuildBlock().mHarvestMaterials);
      
    }
    
    
    
  }
  
}