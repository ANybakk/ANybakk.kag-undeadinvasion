/*
 * UndeadInvasion map
 * 
 * Author: ANybakk
 */

#include "UndeadInvasionPNGLoader.as";



namespace ANybakk {

  namespace UndeadInvasionMap {
  
  
  
    /**
     * Loading function
     */
    bool LoadMap(CMap@ this, const string& in fileName) {

      print("[UndeadInvasionMap:LoadMap] fileName=" + fileName);

      UndeadInvasionPNGLoader loader();

      return loader.loadMap(this, fileName);
      
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