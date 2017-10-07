/* 
 * Zombie blob.
 * 
 * Author: ANybakk
 */
 
#include "[UndeadInvasion]UndeadBlob.as";



namespace UndeadInvasion {

  namespace ZombieBlob {
  
  
  
    void onInit(CBlob@ this) { //Override
      
      UndeadInvasion::UndeadBlob::onInit(this);
      
      setTags(this);
      
    }
    
    
    
    void setTags(CBlob@ this) { //Override
    
      this.Tag("isZombie");
      
    }
    
    
    
  }
  
}