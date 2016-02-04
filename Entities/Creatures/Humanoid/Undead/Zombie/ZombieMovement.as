/* 
 * This script holds everything associated with the movement aspect of the 
 * Zombie entity.
 * 
 * NOTE:  This script relies on the variables set in "ZombieVariables.as", and 
 *        must therefore be bundled together with it, or a derived version, 
 *        within the same name-space.
 * 
 * Author: ANybakk
 */

#include "UndeadMovement.as";



namespace UndeadInvasion {

  namespace ZombieMovement {
  
  
  
    /**
     * Initialization event funcion
     */
    void onInit(CMovement@ this) {
    
      UndeadInvasion::UndeadMovement::onInit(this);
      
    }
    
    
    
    /**
     * Tick event function
     */
    void onTick(CMovement@ this) {
    
      UndeadInvasion::UndeadMovement::onTick(this);
      
    }
    
    
    
  }
  
}