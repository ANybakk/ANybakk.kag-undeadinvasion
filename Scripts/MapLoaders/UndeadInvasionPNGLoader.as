/*
 * UndeadInvasion map loader
 * 
 * Author: ANybakk
 */

#include "BasePNGLoader.as";



const SColor color_zombie_spawn(255, 113,  13, 113);  //Zombie spawn (#710D71)
const SColor color_player_spawn(255, 211, 249, 193);  //Player spawn (#D3F9C1, same as WAR hall)



//Additional stuff to keep track of using offset references
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
    
    //Compare the color value of the map for possible matches, and do the appropriate thing
    switch(color_pixel) {
    
      case color_zombie_spawn:
      
        spawnedBlob = spawnBlob(map, "zombie_spawn", offset, -1); //Spawn blob
				//spawnedBlob.AddScript("abc.as");                          //Add behaviour through a script
				//spawnedBlob.Tag("script added");
        offsets[autotile_offset].push_back(offset);               //Store offset reference, generic
        break;
        
      case color_player_spawn:
      
        spawnedBlob = spawnBlob(map, "hall", offset, -1);         //Spawn blob
				//spawnedBlob.AddScript("abc.as");                          //Add behaviour through a script
				//spawnedBlob.Tag("script added");
        offsets[autotile_offset].push_back(offset);               //Store offset reference, generic
        break;
        
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



/*
bool LoadMap(CMap@ map, const string& in fileName)
{
	print("LOADING WAR PNG MAP " + fileName);

	WarPNGLoader loader();

	return loader.loadMap(map , fileName);
}
*/