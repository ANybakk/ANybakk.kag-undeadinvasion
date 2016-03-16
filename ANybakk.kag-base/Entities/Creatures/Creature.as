/* 
 * Creature
 * 
 * Author: ANybakk
 */

#include "Entity.as"



namespace Creature {



  const string NAME = "Creature";
  
  
  
  shared class Data {
    
    //Options
    
    //EventData (do-once)
    
    //EventData (do-while)
    
    //Body
  
    Body                  bBody;
    
    //Internals
    
  }
  
  
  
  shared class Body {
    
    bool                  oHasFlesh                 = true;
    bool                  oHasBones                 = true;
    bool                  oHasBrain                 = true;
    bool                  oHasLimbs                 = true;
    int                   oArms                     = 0;
    int                   oLegs                     = 0;
    int                   oEyes                     = 2;
  
  }
  
  
  
  namespace Blob {
  
  
  
    /**
     * Stores a data object
     * 
     * @param   this    a blob pointer.
     * @param   data     a data pointer.
     */
    void storeData(CBlob@ this, Data@ data = null) {

      if(data is null) {
      
        @data = Data();
        
      }
      
      this.set(NAME + "::Data", @data);
      
    }
    
    
    
    /**
     * Retrieves a data object.
     * 
     * @param   this    a blob pointer.
     * @return  data     a pointer to the data (null if none was found).
     */
    Data@ retrieveData(CBlob@ this) {
    
      Data@ data;
      
      this.get(NAME + "::Data", @data);
      
      return data;
      
    }
    
    
    
    /**
     * Checks if a target is within range (based on the radius of two blobs).
     * 
     * @param   this            a blob reference.
     * @param   targetBlob      the target blob.
     */
    bool isWithinMeleeRange(CBlob@ this, CBlob@ targetBlob) {
    
      //Check if any of the pointers are invalid
      if(this is null || targetBlob is null) {
      
        return false;
        
      }
      
      //Finished, return true if distance is within the combined radius
      return Entity::Blob::getDistance(this, targetBlob) <= this.getRadius() + targetBlob.getRadius();
      
    }
    
    
    
  }
  
  
  
  namespace Sprite {
  }
  
  
  
  namespace Shape {
  }
  
  
  
  namespace Movement {
  }
  
  
  
  namespace Brain {
  }
  
  
  
  namespace Attachment {
  }
  
  
  
  namespace Inventory {
  }
  
  
  
}