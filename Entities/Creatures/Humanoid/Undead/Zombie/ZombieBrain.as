/* 
 * This script holds everything associated with the brain aspect of the Zombie 
 * entity.
 * 
 * NOTE:  This script relies on the variables set in "ZombieVariables.as", and 
 *        must therefore be bundled together with it, or a derived version, 
 *        within the same name-space.
 * 
 * Author: ANybakk
 */

#define SERVER_ONLY

#include "UndeadBrain.as";



namespace UndeadInvasion {

  namespace ZombieBrain {
  
  
  
    /**
     * Initialization event function
     */
    void onInit(CBrain@ this) {
    
      UndeadInvasion::UndeadBrain::onInit(this);
      
    }
    
    
    
    /**
     * Tick event function
     */
    void onTick(CBrain@ this) {
    
      UndeadInvasion::UndeadBrain::onTick(this);
      
    }
    
    
    
  }
  
}