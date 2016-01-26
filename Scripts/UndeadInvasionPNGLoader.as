/*
 * UndeadInvasion map loader
 * 
 * This script takes care of loading UndeadInvasion maps. What makes the maps 
 * different is that they can contain survivor spawns and undead spawns.
 * 
 * Author: ANybakk
 */


#include "UndeadInvasionPNGLoaderVariables.as";

#include "BasePNGLoader.as";



//Additional stuff to keep track of using offset references
//Kept here because it needs to extend offset enumeration in BasePNGLoader.as
enum UndeadInvasionPNGLoaderOffset {
  zombie_poi = offsets_count, //Point of interest (not used)
  zombie_offsets_count        //End reference
};



/**
 * UndeadInvasionPNGLoader
 * Loads maps for Zombie mode
 */
class UndeadInvasionPNGLoader : PNGLoader {



  /**
   * Constructor
   */
  UndeadInvasionPNGLoader()	{
  
    super();
    
    //Extend super class' offset reference array with any custom ones
    int offsetsCountDiff = zombie_offsets_count - offsets_count;
    while (offsetsCountDiff -- > 0) {
      offsets.push_back(array<int>(0));
    }

    //Finished

	}
  
  
  
	/**
   * Handles a pixel in the map
   */
	void handlePixel(SColor color_pixel, int offset) {
  
    //Call super class' version of this method, to make sure we don't miss out on any default behaviour
		PNGLoader::handlePixel(color_pixel, offset);
    
    //Keep a handle for any blob that might be spawned
    CBlob@ spawnedBlob;
    
    //Check if the color value of the map matches undead spawn
    if(color_pixel == UndeadInvasionPNGLoaderVariables::COLOR_MAUSOLEUM) {
      
        @spawnedBlob = spawnBlob(map, "Mausoleum", offset, -1); //Spawn blob
				//@spawnedBlob.AddScript("abc.as");                          //Add behaviour through a script
				//@spawnedBlob.Tag("script added");
        offsets[autotile_offset].push_back(offset);               //Store offset reference, generic
        
    }
    
    //Check if the color value of the map matches survivor spawn
    else if(color_pixel == UndeadInvasionPNGLoaderVariables::COLOR_SURVIVOR_CAMP) {
      
        @spawnedBlob = spawnBlob(map, "SurvivorCamp", offset, -1);         //Spawn blob
				//@spawnedBlob.AddScript("abc.as");                          //Add behaviour through a script
				//@spawnedBlob.Tag("script added");
        offsets[autotile_offset].push_back(offset);               //Store offset reference, generic
        
    }
    
    //Finished
    
	}
  
  
  
	/**
   * Handles addition of any offset references, post-load 
   */
	void handleOffset(int type, int offset, int position, int count) {
  
    //Call super class' version of this method, to make sure we don't miss out on any default behaviour
		PNGLoader::handleOffset(type, offset, position, count);
		
		//Finished
    
	}
  
  
  
  //Class declaration done
  
}