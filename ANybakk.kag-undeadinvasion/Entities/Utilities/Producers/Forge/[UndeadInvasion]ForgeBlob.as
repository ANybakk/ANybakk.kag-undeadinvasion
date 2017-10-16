/* 
 * Forge blob.
 * 
 * Author: ANybakk
 */

#include "[UndeadInvasion]ProducerBlob.as";
#include "[UndeadInvasion]ForgeBuildBlock.as";



namespace UndeadInvasion {

  namespace ForgeBlob {
  
  
  
    /**
     * Initializes this entity
     */
    void onInit(CBlob@ this) {
      
      UndeadInvasion::ProducerBlob::onInit(this);
      
      setTags(this);
      setCommands(this);
      setHarvestMaterials(this);
      
      this.set_bool("fuelled", !ProducerVariables::hasMaterialStorage);
      
    }
  
    
    
    /**
     * Sets various tags for this entity type.
     * 
     * @param   this            a blob reference.
     */
    void setTags(CBlob@ this) {
    
      this.Tag("isForgeBlob");
      
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
    
      this.set("harvest", ForgeBuildBlock().mHarvestMaterials);
      
    }
    
    
    
    /**
     * Tick event function
     */
    void onTick(CBlob@ this) {
    
      UndeadInvasion::ProducerBlob::onTick(this);
      
      //Check if storage enabled
      if(ProducerVariables::hasMaterialStorage) {
      
        //Obtain inventory reference
        CInventory@ inventory = this.getInventory();
        
        //Check if fuel present
        if(inventory !is null && inventory.getCount("mat_wood") >= 0) {
        
          this.set_bool("fuelled", true);
          
        }
        
        //Otherwise, no fuel present
        else {
        
          this.set_bool("fuelled", false);
          
        }
        
      }
      
    }
    
    
    
  }
  
}