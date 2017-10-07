/*
 * Bed build block.
 * For use with Builder's build options and harvesting.
 * 
 * Author: ANybakk
 */

#include "BuildBlock.as";



/**
 * Forms a convenient basis to keep stuff related to blob
 */
class BedBuildBlock : BuildBlock {
  
  dictionary mHarvestMaterials;
  
  BedBuildBlock() {
  
    super(0, "Bed", "$Bed$", "Bed\nSleep tight");
    
    //Repeat following for each material required for building
    reqs.write_string("blob");              //Type (blob, coin, no more, no less, tech)
    reqs.write_string("mat_wood");          //Name
    reqs.write_string("Wood");              //Caption
    reqs.write_u16(12);                     //Quantity (two logs)
    
    //Repeat the following for each material returned from harvesting
		mHarvestMaterials.set('mat_wood', 2);  //Name, Quantity per 1.0 damage (one per hit)
    
    //Additional options
    buildOnGround = true;
    size.Set(24, 16);
    
  }
  
  
  
}