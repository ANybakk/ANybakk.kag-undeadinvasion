/*
 * UndeadInvasion map
 * 
 * This script takes care of map loading.
 * 
 * Author: ANybakk
 */

#include "[UndeadInvasion]Variables.as";
#include "[UndeadInvasion]DefaultPNGLoader.as";



namespace UndeadInvasion {

  namespace Map {
  
  
  
    void onInit(CMap@ this) {
    
      print("[UndeadInvasion::Map::onInit]");
      
      this.set_u32("nextGrassCandidateIndex", 0);
      
    }
    
    
    
    /**
     * Loading function
     */
    bool LoadMap(CMap@ this, const string& in fileName) {
    
      print("[UndeadInvasion::Map::LoadMap] fileName=" + fileName);
      
      UndeadInvasion::DefaultPNGLoader loader();
      
      return loader.loadMap(this, fileName);
      
    }
    
    
    
    /**
     * Tick function
     */
    void onTick(CMap@ this) {
    
      f32 vGrassGrowthStepTime = UndeadInvasionVariables::GRASS_GROWTH_STEP_TIME;
      
      //Check if zero or positive (not disabled)
      if(vGrassGrowthStepTime >= 0.0f) {
        
        //Check if zero (do every tick) or if time to grow grass
        if(vGrassGrowthStepTime == 0.0f || getGameTime() % (vGrassGrowthStepTime * getTicksASecond()) == 0){
        
          //Grow grass
          growGrassCandidates(this, UndeadInvasionVariables::GRASS_GROWTH_STEP_AMOUNT);
          
        }
        
      }
      
    }
    
    
    
    /**
     * Grows any grass for a certain number of tiles. This is a continuous state driven procedure.
     */
    void growGrassCandidates(CMap@ this, u8 numberOfTiles = 1) {
    
      //Retrieve all grass candidate offsets
      int[] grassCandidateOffsets;
      this.get("grassCandidateOffsets", grassCandidateOffsets);
      
      //Retrive next candidate index 
      u32 nextGrassCandidateIndex = this.get_u32("nextGrassCandidateIndex");
      
      int nextOffset;
      Tile tile;
      Vec2f position;
      
      for(int i=0; i<numberOfTiles; i++) {
        
        //Find next offset
        nextOffset = grassCandidateOffsets[nextGrassCandidateIndex];
        
        //Find tile
        tile = this.getTile(nextOffset);
        
        //Check if grass type and not yet fully grown (Thank you, Geti)
        if(this.isTileGrass(tile.type) && tile.type != CMap::tile_grass) {
        
          //Get position
          position = this.getTileWorldPosition(nextOffset);
          
          //Grow grass (grass tiles are in decreasing order)
          this.server_SetTile(position, tile.type - 1);
          
        }
        
        //Increment
        nextGrassCandidateIndex++;
        
        //Start over if end is reached
        if(nextGrassCandidateIndex > grassCandidateOffsets.length - 1) {
          nextGrassCandidateIndex = 0;
        }
      
      }
      
      //Update index
      this.set_u32("nextGrassCandidateIndex", nextGrassCandidateIndex);
      
    }
    
    
    
    /**
     * Retrieves a set of tiles. The result uses the same indexing as the input.
     * 
     * @param   positions   a 2D array of vectors representing all the possible tile positions
     * @returns             a 2D array of tiles
     */
    Tile[][] getTiles(CMap@ this, Vec2f[][] positions) {
    
      //Create the array
      Tile[][] result;
      
      //Iterate through first level
      for(int i=0; i<positions.length; i++) {
      
        Tile[] group;
      
        //Iterate through second level
        for(int j=0; j<positions[i].length; j++) {
        
          //Retrieve any tile at this position
          group.push_back(this.getTile(positions[i][j]));
          
        }
        
        result.push_back(group);
        
      }
      
      //Finished, return result
      return result;
      
    }
    
    
    
  }
  
}