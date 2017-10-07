/* 
 * Generic blob
 * 
 * Author: ANybakk
 */



namespace UndeadInvasion {

  namespace Blob {
  
  
  
    /**
     * Initializes this entity
     */
    void onInit(CBlob@ this) {
      
      setTags(this);
      setCommands(this);
      setHarvestMaterials(this);
      
    }
  
    
    
    /**
     * Sets various tags for this entity type. Inheriting types should call this.
     * 
     * @param   this            a blob reference.
     */
    void setTags(CBlob@ this) {
    
      this.Tag("isBlob");
      
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
     * @param   target          the target blob.
     */
    Vec2f getVector(CBlob@ this, CBlob@ target) {
      
      //Finished, return result from other version of this method
      return getVector(this, target.getPosition());
      
    }
    
    
    
    /**
     * Returns the distance between a blob and a position.
     * 
     * @param   this            a blob reference.
     * @param   targetPosition  the target position.
     */
    f32 getDistance(CBlob@ this, Vec2f targetPosition) {
      
      //Finished, return distance
      return (targetPosition - this.getPosition()).getLength();
      
    }
    
    
    
    /**
     * Returns the distance between two blobs.
     * 
     * @param   this            a blob reference.
     * @param   target          the target blob.
     */
    f32 getDistance(CBlob@ this, CBlob@ target) {
      
      //Finished, return result from the other version of this method
      return getDistance(this, target.getPosition());
      
    }
    
    
    
    /**
     * Returns true if a blob has lost any amount of health
     */
    bool isDamaged(CBlob@ this) {
    
      return this.getHealth() < this.getInitialHealth();
    
    }

    
    
    
  }
  
}