/* 
 * Log sprite
 * 
 * Author: ANybakk
 */



namespace UndeadInvasion {

  namespace LogSprite {
  
  
  
    /**
     * Initializes this entity
     */
    void onInit(CSprite@ this) {
    
      //Set random frame
      this.animation.frame = XORRandom(4);
      
      //Remove script (nothing more to do)
      this.getCurrentScript().runFlags |= Script::remove_after_this;
      
    }
    
  }
  
}