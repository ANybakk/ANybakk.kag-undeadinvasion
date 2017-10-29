/* 
 * Producer ingredient blob
 * 
 * Author: ANybakk
 */



namespace UndeadInvasion {

  namespace ProductionIngredientBlob {
  
  
  
    /**
     * Initializes this entity
     */
    void onInit(CBlob@ this) {
    
      this.set_bool("ProductionIngredientBlob::isLocked", false);
      
    }
    
    
    
    /**
     * Pick up check
     */
    bool canBePickedUp(CBlob@ this, CBlob@ byBlob) {
    
      //If not locked
      return !this.get_bool("ProductionIngredientBlob::isLocked");
      
    }
    
    
    
    void onAttach(CBlob@ this, CBlob@ attached, AttachmentPoint @attachedPoint) {
    
      //Set invisible if producer
      if(attached.hasTag("isProducerBlob")) {
        this.SetVisible(false);
      }
      
    }
    
    
    
    void onDetach(CBlob@ this, CBlob@ detached, AttachmentPoint@ attachedPoint) {
    
      //Set visible if producer
      if(detached.hasTag("isProducerBlob")) {
        this.SetVisible(true);
      }
      
    }
    
    
    
    /**
     * Toggles a "ingredient" entity's pick up attachment point
     */
    void toggleIngredientPickUp(CBlob@ this) {
    
      AttachmentPoint@[] attachmentPoints;
      
      if(this.getAttachmentPoints(attachmentPoints)) {
      
        AttachmentPoint@ attachmentPoint;
        
        for(int i=0; i<attachmentPoints.length; i++) {
        
          @attachmentPoint = attachmentPoints[i];
          
          if(attachmentPoint.name == "PICKUP") {
            attachmentPoint.name = "INGREDIENT_NOPICKUP";
          }
          
          else if(attachmentPoint.name == "INGREDIENT_NOPICKUP") {
            attachmentPoint.name = "PICKUP";
          }
          
        }
        
      }
      
    }
    
    
    
  }
  
}