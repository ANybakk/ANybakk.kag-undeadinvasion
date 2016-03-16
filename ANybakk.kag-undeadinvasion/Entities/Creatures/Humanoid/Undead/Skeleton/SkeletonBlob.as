/* 
 * Skeleton blob.
 * 
 * Author: ANybakk
 */



namespace ANybakk {

  class SkeletonBlob {
  
  
  
    void onInit(CBlob@ this) {
      
      this.Untag("CreatureBlob::isMadeOfFlesh");
      this.Untag("flesh"); //Vanilla tag that allows being targeted by a bison for instance
      this.Untag("HumanoidBlob::hasEyes");
      this.Tag("isSkeleton");
      
    }
    
    
    
  }
  
}