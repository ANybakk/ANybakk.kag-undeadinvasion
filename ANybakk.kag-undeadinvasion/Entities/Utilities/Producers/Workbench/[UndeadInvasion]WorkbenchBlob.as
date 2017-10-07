/* 
 * Workbench blob.
 * 
 * Author: ANybakk
 */

#include "[UndeadInvasion]ProducerBlob.as";
#include "[UndeadInvasion]WorkbenchBuildBlock.as";



namespace UndeadInvasion {

  namespace WorkbenchBlob {
  
  
  
    /**
     * Initializes this entity
     */
    void onInit(CBlob@ this) {
      
      UndeadInvasion::ProducerBlob::onInit(this);
      
      setTags(this);
      setCommands(this);
      setHarvestMaterials(this);
      
    }
  
    
    
    /**
     * Sets various tags for this entity type.
     * 
     * @param   this            a blob reference.
     */
    void setTags(CBlob@ this) {
    
      this.Tag("isWorkbenchBlob");
      
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
    
      this.set("harvest", WorkbenchBuildBlock().mHarvestMaterials);
      
    }
    
    
    
    /**
     * Tick event function
     */
    void onTick(CBlob@ this) {
    
      UndeadInvasion::ProducerBlob::onTick(this);
      
    }
    
    
    
  }
  
}