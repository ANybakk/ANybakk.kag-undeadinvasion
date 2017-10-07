/* 
 * Skeleton blob.
 * 
 * Author: ANybakk
 */
 
#include "[UndeadInvasion]UndeadBlob.as";



namespace UndeadInvasion {

  namespace SkeletonBlob {
  
  
  
    void onInit(CBlob@ this) { //Override
      
      UndeadInvasion::UndeadBlob::onInit(this);
      
      setTags(this);
      
    }
  
    
    
    void setTags(CBlob@ this) { //Override
      
      this.Untag("isMadeOfFlesh");
      this.Untag("hasEyes");
      this.Tag("isSkeleton");
      
    }
    
    
    
  }
  
}