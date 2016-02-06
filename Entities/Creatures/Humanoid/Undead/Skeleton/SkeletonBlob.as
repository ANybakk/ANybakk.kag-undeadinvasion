/* 
 * Skeleton blob.
 * 
 * Author: ANybakk
 */
 
#include "UndeadBlob.as";



namespace UndeadInvasion {

  namespace SkeletonBlob {
  
  
  
    void onInit(CBlob@ this) { //Override
      
      UndeadInvasion::UndeadBlob::onInit(this);
      
      setTags(this);
      
    }
  
    
    
    void setTags(CBlob@ this) { //Override
      
      this.Untag("isMadeOfFlesh");
      this.Untag("flesh"); //Vanilla tag that allows being targeted by a bison for instance
      this.Untag("hasEyes");
      this.Tag("isSkeleton");
      
    }
    
    
    
  }
  
}