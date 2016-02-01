/*
 * UndeadInvasion Creature blob (ABSTRACT)
 * 
 * This script handles anything general related to Creature entity blobs.
 * 
 * NOTE: This script relies on the variables set in "CreatureVariables.as", and 
 *       must therefore be bundled together with it, or a derived version.
 * 
 * COMMENT: Custom methods are wrapped in name-spaces to distinguish them from 
 *          the built-in ones and to avoid naming conflicts
 * 
 * Author: ANybakk
 */



namespace UndeadInvasion {

  namespace CreatureBlob {
  
    
    
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
     * Checks if a target is within range (based on the radius of two blobs).
     * 
     * @param   this            a blob reference.
     * @param   target          the target blob.
     */
    bool isWithinMeleeRange(CBlob@ this, CBlob@ target) {
      
      //Finished, return true if distance is within the combined radius
      return getDistance(this, target) <= this.getRadius() + target.getRadius();
      
    }
    
    
    
  }
  
}