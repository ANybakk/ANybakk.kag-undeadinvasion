/* 
 * Workbench blob.
 * 
 * Author: ANybakk
 */

#include "ProducerBlob.as";



namespace UndeadInvasion {

  namespace WorkbenchBlob {
  
  
  
    /**
     * Initializes this entity
     */
    void onInit(CBlob@ this) {
      
      UndeadInvasion::ProducerBlob::onInit(this);
      
      setTags(this);
      setCommands(this);
      
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
	
    }
    
    
    
    /**
     * Tick event function
     */
    void onTick(CBlob@ this) {
    
      UndeadInvasion::ProducerBlob::onTick(this);
      
    }
    
    
    
  }
  
}