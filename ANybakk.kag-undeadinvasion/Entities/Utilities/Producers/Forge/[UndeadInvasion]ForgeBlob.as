/* 
 * Forge blob.
 * 
 * Author: ANybakk
 */

#include "[UndeadInvasion]ProducerBlob.as";
#include "[UndeadInvasion]ForgeBuildBlock.as";
#include "[UndeadInvasion]ForgeFuelType.as";



namespace UndeadInvasion {

  namespace ForgeBlob {
  
  
  
    void onInit(CBlob@ this) {
      
      UndeadInvasion::ProducerBlob::onInit(this);
      
      setTags(this);
      setCommands(this);
      setHarvestMaterials(this);
      
      //Check if storage enabled
      if(ProducerVariables::hasMaterialStorage) {
        this.set_u8("fuelState", UndeadInvasion::ForgeFuelType::NONE);
      }
      else {
        this.set_u8("fuelState", UndeadInvasion::ForgeFuelType::WOOD);
      }
      
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
        
        //Check if coal fuel present
        //TODO: Check matlock too
        if(inventory !is null && inventory.getCount("mat_coal") >= 0) {
        
          this.set_u8("fuelState", UndeadInvasion::ForgeFuelType::COAL);
          
        }
        
        //Otherwise, check if log fuel present
        else if(inventory !is null && inventory.getCount("Log") >= 0) {
        
          this.set_u8("fuelState", UndeadInvasion::ForgeFuelType::WOOD);
          
        }
        
        //Otherwise, no fuel present
        else {
        
          this.set_u8("fuelState", UndeadInvasion::ForgeFuelType::NONE);
          
        }
        
      }
      
    }
    
    
    
  }
  
}