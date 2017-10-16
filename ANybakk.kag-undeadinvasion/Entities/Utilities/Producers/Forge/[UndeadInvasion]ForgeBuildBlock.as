/*
 * Forge build block.
 * For use with Builder's build options and harvesting.
 * 
 * Author: ANybakk
 */

#include "BuildBlock.as";



/**
 * Forms a convenient basis to keep stuff related to blob
 */
class ForgeBuildBlock : BuildBlock {
  
  dictionary mHarvestMaterials;
  
  ForgeBuildBlock() {
  
    super(0, "Forge", "$Forge$", "Forge\nFor creating things with heat");
    
    //Repeat following for each material required for building
    reqs.write_string("blob");              //Type (blob, coin, no more, no less, tech)
    reqs.write_string("mat_stone");         //Name
    reqs.write_string("Stone");             //Caption
    reqs.write_u16(12);                     //Quantity
    
    //Repeat the following for each material returned from harvesting
		mHarvestMaterials.set('mat_stone', 2);   //Name, Quantity per 1.0 damage (one per hit)
    
    //Additional options
    buildOnGround = true;
    size.Set(16, 24);
    
  }
  
  
  
}