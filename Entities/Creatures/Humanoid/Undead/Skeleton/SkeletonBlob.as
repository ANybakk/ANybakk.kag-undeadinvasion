/* 
 * This script holds everything associated with the blob aspect of the Skeleton 
 * entity. That excludes things related to AI brains, AI movement etc.
 * 
 * NOTE:  This script relies on the variables set in "SkeletonVariables.as", and 
 *        must therefore be bundled together with it, or a derived version, 
 *        within the same name-space(s).
 * 
 * Author: ANybakk
 */
 
#include "UndeadBlob.as";



namespace UndeadInvasion {

  namespace Skeleton {
  
  
  
    /**
     * Initializes this entity
     */
    void onInit(CBlob@ this) {
      
      UndeadInvasion::UndeadBlob::doInit(this);
      
      setTags(this);
      
    }
  
    
    
    /**
     * Sets various tags for this entity type. Inheriting types should call this.
     * 
     * @param   this            a blob reference.
     */
    void setTags(CBlob@ this) {
      
      this.Untag("isMadeOfFlesh");
      this.Untag("hasEyes");
      this.Tag("isSkeleton");
      
    }
    
    
    
  }
  
}