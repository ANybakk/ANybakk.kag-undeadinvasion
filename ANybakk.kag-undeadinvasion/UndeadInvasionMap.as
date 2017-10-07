/*
 * UndeadInvasion map
 * 
 * This script takes care of map loading.
 * 
 * COMMENT: Custom methods are wrapped in name-spaces to distinguish them from 
 *          the built-in ones and to avoid naming conflicts
 * 
 * Author: ANybakk
 */

#include "UndeadInvasionPNGLoader.as";



void onInit(CMap@ this) {

  this.set_u32("nextGrassCandidateIndex", 0);
  
}



/**
 * Loading function
 */
bool LoadMap(CMap@ this, const string& in fileName) {

  print("[UndeadInvasionMap:LoadMap] fileName=" + fileName);

  UndeadInvasionPNGLoader loader();
  
  return loader.loadMap(this, fileName);
  
}

void onTick(CMap@ this) {

  //Retrieve all grass candidate offsets
  int[] grassCandidateOffsets;
  this.get("grassCandidateOffsets", grassCandidateOffsets);
  
  //Retrive next candidate index 
  u32 nextGrassCandidateIndex = this.get_u32("nextGrassCandidateIndex");
  
  //Find next offset
  int nextOffset = grassCandidateOffsets[nextGrassCandidateIndex];
  
  //Find tile
  Tile tile = this.getTile(nextOffset);
  print("type:" + tile.type);
  //Check if grass type and not yet fully grown (Thank you, Geti)
  if(this.isTileGrass(tile.type) && tile.type != CMap::tile_grass) {
  
    //Get position
    Vec2f position = this.getTileWorldPosition(nextOffset);
    
    //Grow grass (grass tiles are in decreasing order)
    this.server_SetTile(position, tile.type - 1);
    
  }
  
  //Increment
  nextGrassCandidateIndex++;
  
  //Start over if end is reached
  if(nextGrassCandidateIndex > grassCandidateOffsets.length - 1) {
    nextGrassCandidateIndex = 0;
  }
  
  //Update index
  this.set_u32("nextGrassCandidateIndex", nextGrassCandidateIndex);
  
}



namespace UndeadInvasion {

  namespace Map {
  
  
  
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