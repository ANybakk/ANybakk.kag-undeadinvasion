/*
 * UndeadInvasion map loader
 * 
 * This script takes care of loading UndeadInvasion maps. What makes the maps 
 * different is that they can contain survivor spawns and undead spawns. In 
 * addition, it will load an optional sector map. The sector map should have 
 * the same name with "Sectors" appended to it. The file ending is .png as 
 * usual.
 * 
 * The map loader stores all sky tiles or grass tiles that has a dirt tile 
 * underneath, for use with grass growth.
 * 
 * Author: ANybakk
 */

#include "LoaderColors.as";
#include "BasePNGLoader.as";

#include "[UndeadInvasion]DefaultPNGLoaderVariables.as";
#include "[UndeadInvasion]Map.as";
#include "[UndeadInvasion]MapVariables.as";




namespace UndeadInvasion {

  //Enumeration used when storing special offsets when loading a map (extends enumeration in BasePNGLoader.as)
  enum PNGLoaderOffset {
    UNDEADINVASION_POI = offsets_count + 1, //Point of interest (not used)
    UNDEADINVASION_GRASS_CANDIDATE,         //Sky tiles (for post-stage check for grass growth)
    UNDEADINVASION_OFFSETS_COUNT            //End reference
  };

  //Enumeration used when storing special offsets when loading a sector map
  enum PNGLoaderSectorOffset {
    NOBUILD_START = 0,          //No-build sector start point
    NOBUILD_END,                //No-build sector end point
    SECTOR_OFFSETS_COUNT        //End reference
  };
  
  /**
   * UndeadInvasionPNGLoader
   * Loads maps for Zombie mode
   */
  class DefaultPNGLoader : ::PNGLoader {



    //Keep an array of grass candidate tile offsets
    int[] mGrassCandidateOffsets;
    
    //Keep a store of sector map offsets
    array<array<int>> mSectorOffsets;



    /**
     * Constructor
     */
    DefaultPNGLoader()	{
    
      super();
      
      //Extend super class' offset reference array with any custom ones
      int offsetsCountDiff = UNDEADINVASION_OFFSETS_COUNT - offsets_count;
      while (offsetsCountDiff -- > 0) {
        offsets.push_back(array<int>(0));
      }
      
      //Initialize sector offset array
      mSectorOffsets = array<array<int>>(SECTOR_OFFSETS_COUNT, array<int>(0));

      //Finished

    }
    
    
    
    /**
     * Handles loading of a map
     */
    bool loadMap(CMap@ map, const string& in filename) override {
    
      bool result = false;
      
      //Call super class' version of this method
      result = PNGLoader::loadMap(map, filename);
      
      //Store grass candidate tile offsets
      map.set("grassCandidateOffsets", mGrassCandidateOffsets);
      
      //Derive the map's name from file name
      string mapName = filename.substr(0, filename.length()-4);
      
      //Derive the map's file type from file name
      string mapType = filename.substr(filename.length()-3, -1);
      
      //Attempt to load a secondary sector map with the same name and type
      CFileImage@ sectorMapImage = CFileImage(mapName + "Sectors." + mapType);
      
      //Check if the image was loaded succesfully
      if(sectorMapImage.isLoaded()) {
        print("sectormap loaded");
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
          
          //Call helper method (stores needed offsets in mSectorOffsets)
          handleSectorPixel(pixelColor, pixelOffset);

          //Keep connections alive (?)
          getNet().server_KeepConnectionsAlive();

        }
        
        //Iterate through no-build sectors
        for(uint i = 0; i < mSectorOffsets[NOBUILD_START].length; ++i) {
        
          //Check if there is at least one matching end offset
          if(mSectorOffsets[NOBUILD_END].length >= i + 1) {
          
            //Determine start coordinates
            Vec2f startCoordinate = map.getTileWorldPosition(mSectorOffsets[NOBUILD_START][i]);
            
            //Determine end coordinates
            Vec2f endCoordinate = map.getTileWorldPosition(mSectorOffsets[NOBUILD_END][i]);
            
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
      
      CBlob@ spawnedBlob;
      
      if(color_pixel == UndeadInvasion::DefaultPNGLoaderVariables::COLOR_TILE_IRON) {
      
        map.SetTile(offset, UndeadInvasion::MapVariables::TILE_OFFSETS_IRON[0]);
        map.AddTileFlag(offset, UndeadInvasion::MapVariables::TILE_FLAGS_IRON);
        
      }
      
      //Check if the color value of the map matches undead spawn
      else if(color_pixel == UndeadInvasion::DefaultPNGLoaderVariables::COLOR_MAUSOLEUM) {
        
        @spawnedBlob = spawnBlob(map, "Mausoleum", offset, -1);     //Spawn blob
        //@spawnedBlob.AddScript("abc.as");                         //Add behaviour through a script
        //@spawnedBlob.Tag("script added");
        offsets[autotile_offset].push_back(offset);                 //Store offset reference, generic tile
        
      }
      
      //Check if the color value of the map matches survivor spawn
      else if(color_pixel == UndeadInvasion::DefaultPNGLoaderVariables::COLOR_SURVIVOR_CAMP) {
        
        @spawnedBlob = spawnBlob(map, "SurvivorCamp", offset, -1);  //Spawn blob
        //@spawnedBlob.AddScript("abc.as");                         //Add behaviour through a script
        //@spawnedBlob.Tag("script added");
        offsets[autotile_offset].push_back(offset);                 //Store offset reference, generic tile
        
        //TODO: For some reason, the default offset handler doesn't repair the correct tile
        
      }
      
      //Check if Bed
      else if(color_pixel == UndeadInvasion::DefaultPNGLoaderVariables::COLOR_BED) {
      
        @spawnedBlob = spawnBlob(map, "Bed", offset, -1);            //Spawn blob
        offsets[autotile_offset].push_back(offset);                  //Store offset reference, generic tile

      }
      
      //Check if empty/sky
      else if(color_pixel == sky || color_pixel == color_tile_grass) {
      
        offsets[UNDEADINVASION_GRASS_CANDIDATE].push_back(offset);                //Store offset reference
        
      }
      
      //Finished
      return;
      
    }
    
    
    
    /**
     * Handles a pixel in the sector map
     */
    void handleSectorPixel(SColor pixelColor, int pixelOffset) {
    
      //Check if the color value matches no-build sector start
      if(pixelColor == UndeadInvasion::DefaultPNGLoaderVariables::COLOR_SECTOR_NOBUILD_START) {
      
        mSectorOffsets[NOBUILD_START].push_back(pixelOffset); //Store offset reference, no-build start point
        
      }

      //Check if the color value matches no-build sector start
      if(pixelColor == UndeadInvasion::DefaultPNGLoaderVariables::COLOR_SECTOR_NOBUILD_END) {
      
        mSectorOffsets[NOBUILD_END].push_back(pixelOffset); //Store offset reference, no-build end point
        
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
      
      //If grass candidate
      if(type == UNDEADINVASION_GRASS_CANDIDATE) {
      
        //Determine offset number for tile below
        int belowOffset = offset + map.tilemapwidth;
        
        //Determine offset number for the very last tile in the map
        int lastOffset = map.tilemapwidth * map.tilemapheight - 1;
        
        //Check if tile below is dirt/ground
        if(belowOffset <= lastOffset && map.getTile(belowOffset).type == CMap::tile_ground) {
        
          //Add this tile's offset
          mGrassCandidateOffsets.push_back(offset);
          
        }
        
      }
      
      //Finished
      return;
      
    } //End method
    
    
    
  } //End class
  
} //End namespace