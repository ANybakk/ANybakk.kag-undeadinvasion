/*
 * Blob build block template.
 * For use with Builder's build options and harvesting.
 * 
 * Author: ANybakk
 */

#include "BuildBlock.as";



/**
 * Forms a convenient basis to keep stuff related to blob
 */
class BlobBuildBlock : BuildBlock {
  
  dictionary mHarvestMaterials;
  
  BlobBuildBlock() {
  
    super(0, "Blob", "$Blob$", "Generic entity");
    
    //Repeat following for each material required for building
    //reqs.write_string("blob");              //Type (blob, coin, no more, no less, tech)
    //reqs.write_string("mat_wood");          //Name
    //reqs.write_string("Wood");              //Caption
    //reqs.write_u16(10);                     //Quantity
    
    //Repeat the following for each material returned from harvesting
		//mHarvestMaterials.set('mat_wood', 2);   //Name, Quantity per 1.0 damage
    
    //Additional options
    //buildOnGround = true;
    //size.Set(32, 16);
    
  }
  
  
  
}