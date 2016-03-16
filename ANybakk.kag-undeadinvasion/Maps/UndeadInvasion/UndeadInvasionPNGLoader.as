/*
 * UndeadInvasion map loader
 * 
 * This script takes care of loading UndeadInvasion maps. What makes the maps 
 * different is that they can contain survivor spawns and undead spawns. In 
 * addition, it will load an optional sector map. The sector map should have 
 * the same name with "Sectors" appended to it. The file ending is .png as 
 * usual.
 * 
 * Author: ANybakk
 */


#include "UndeadInvasionPNGLoaderVariables.as";

#include "BasePNGLoader.as";



//Enumeration used when storing special offsets when loading a map (extends enumeration in BasePNGLoader.as)
enum UndeadInvasionPNGLoaderOffset {
  UNDEADINVASION_POI = offsets_count, //Point of interest (not used)
  UNDEADINVASION_OFFSETS_COUNT        //End reference
};

//Enumeration used when storing special offsets when loading a sector map
enum UndeadInvasionPNGLoaderSectorOffset {
  NOBUILD_START = 0,         //No-build sector start point
  NOBUILD_END,               //No-build sector end point
  SECTOR_OFFSETS_COUNT        //End reference
};



/**
 * UndeadInvasionPNGLoader
 * Loads maps for Zombie mode
 */
class UndeadInvasionPNGLoader : PNGLoader {



  //Keep a store of sector map offsets
	array<array<int>> sectorOffsets;



  /**
   * Constructor
   */
  UndeadInvasionPNGLoader()	{
  
    super();
    
    //Extend super class' offset reference array with any custom ones
    int offsetsCountDiff = UNDEADINVASION_OFFSETS_COUNT - offsets_count;
    while (offsetsCountDiff -- > 0) {
      offsets.push_back(array<int>(0));
    }
    
    //Initialize sector offset array
    sectorOffsets = array<array<int>>(SECTOR_OFFSETS_COUNT, array<int>(0));

    //Finished

	}
  
  
  
  /**
   * Handles loading of a map
   */
  bool loadMap(CMap@ map, const string& in filename) override {
  
    bool result = false;
    
    //Call super class' version of this method
    result = PNGLoader::loadMap(map, filename);
    
    //Derive the map's name from file name
    string mapName = filename.substr(0, filename.length()-4);
    
    //Derive the map's file type from file name
    string mapType = filename.substr(filename.length()-3, -1);
    
    //Attempt to load a secondary sector map with the same name and type
    CFileImage@ sectorMapImage = CFileImage(mapName + "Sectors." + mapType);
    
    //Check if the image was loaded succesfully
		if(sectorMapImage.isLoaded()) {
      
      //Create a pixel color variable
      SColor pixelColor;
      
      //Create a pixel offset variable
      int pixelOffset;
      
      //Iterate through all pixels
      while(sectorMapImage.nextPixel()) {

        //Obtain pixel color value
        pixelColor = sectorMapImage.readPixel();

        //Obtain offset
        pixelOffset = sectorMapImage.getPixelOffset();
        
        //Call helper method (stores needed offsets in sectorOffsets)
        handleSectorPixel(pixelColor, pixelOffset);

        //Keep connections alive (?)
        getNet().server_KeepConnectionsAlive();

      }
      
      //Iterate through no-build sectors
      for(uint i = 0; i < sectorOffsets[NOBUILD_START].length; ++i) {
      
        //Check if there is at least one matching end offset
        if(sectorOffsets[NOBUILD_END].length >= i + 1) {
        
          //Determine start coordinates
          Vec2f startCoordinate = map.getTileWorldPosition(sectorOffsets[NOBUILD_START][i]);
          
          //Determine end coordinates
          Vec2f endCoordinate = map.getTileWorldPosition(sectorOffsets[NOBUILD_END][i]);
          
          //Check if end coordinate is below and to the right of start coordinate
          if(endCoordinate.x - startCoordinate.x > 0 && endCoordinate.y - startCoordinate.y > 0) {
          
            //Add no-build sector (Correct coordinates to include last row/column)
            map.server_AddSector(startCoordinate, endCoordinate + Vec2f(0.0f + map.tilesize, 0.0f + map.tilesize), "no build");
            
          }
          
        }

        //Keep connections alive (?)
        getNet().server_KeepConnectionsAlive();
        
      }

    }
    
    //Finished, return result
    return result;
    
  }
  
  
  
	/**
   * Handles a pixel in the map
   */
	void handlePixel(SColor color_pixel, int offset) override {
  
    //Call super class' version of this method, to make sure we don't miss out on any default behaviour
		PNGLoader::handlePixel(color_pixel, offset);
    
    //Keep a handle for any blob that might be spawned
    CBlob@ spawnedBlob;
    
    //Check if the color value of the map matches undead spawn
    if(color_pixel == UndeadInvasionPNGLoaderVariables::COLOR_MAUSOLEUM) {
      
        @spawnedBlob = spawnBlob(map, "Mausoleum", offset, -1);   //Spawn blob
				//@spawnedBlob.AddScript("abc.as");                       //Add behaviour through a script
				//@spawnedBlob.Tag("script added");
        offsets[autotile_offset].push_back(offset);               //Store offset reference, generic tile
        
    }
    
    //Check if the color value of the map matches survivor spawn
    else if(color_pixel == UndeadInvasionPNGLoaderVariables::COLOR_SURVIVOR_CAMP) {
      
        @spawnedBlob = spawnBlob(map, "Camp", offset, -1);        //Spawn blob
				//@spawnedBlob.AddScript("abc.as");                       //Add behaviour through a script
				//@spawnedBlob.Tag("script added");
        offsets[autotile_offset].push_back(offset);               //Store offset reference, generic tile
        
        //TODO: For some reason, the default offset handler doesn't repair the correct tile
        //Because super class' version is called first?
        
    }
    
    //Finished
    return;
    
	}
  
  
  
  /**
   * Handles a pixel in the sector map
   */
  void handleSectorPixel(SColor pixelColor, int pixelOffset) {
  
    //Check if the color value matches no-build sector start
    if(pixelColor == UndeadInvasionPNGLoaderVariables::COLOR_SECTOR_NOBUILD_START) {
    
      sectorOffsets[NOBUILD_START].push_back(pixelOffset); //Store offset reference, no-build start point
      
    }

    //Check if the color value matches no-build sector start
    if(pixelColor == UndeadInvasionPNGLoaderVariables::COLOR_SECTOR_NOBUILD_END) {
    
      sectorOffsets[NOBUILD_END].push_back(pixelOffset); //Store offset reference, no-build end point
      
    }
    
    //Finished
    return;
  
  }
  
  
  
	/**
   * Handles addition of any offset references, post-load 
   */
	void handleOffset(int type, int offset, int position, int count) override {
  
    //Call super class' version of this method, to make sure we don't miss out on any default behaviour
		PNGLoader::handleOffset(type, offset, position, count);
		
		//Finished
    return;
    
	}
  
  
  
  //Class declaration done
  
}