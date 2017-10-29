/*
 * UndeadInvasion map
 * 
 * This script takes care of map loading.
 * 
 * Author: ANybakk
 */

#include "[UndeadInvasion]MapVariables.as";
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
    
      f32 vGrassGrowthStepTime = UndeadInvasion::MapVariables::GRASS_GROWTH_STEP_TIME;
      
      //Check if zero or positive (not disabled)
      if(vGrassGrowthStepTime >= 0.0f) {
        
        //Check if zero (do every tick) or if time to grow grass
        if(vGrassGrowthStepTime == 0.0f || getGameTime() % (vGrassGrowthStepTime * getTicksASecond()) == 0){
        
          //Grow grass
          growGrassCandidates(this, UndeadInvasion::MapVariables::GRASS_GROWTH_STEP_AMOUNT);
          
        }
        
      }
      
    }
    
    
    
    /**
     * Tile hit function (server-side)
     */
    TileType server_onTileHit(CMap@ this, f32 damage, u32 index, TileType oldTileType) {
    
      TileType newType = oldTileType;
      
      //Check if custom tile (don't mess with vanilla stuff)
      if(oldTileType >= (UndeadInvasion::MapVariables::TILE_ROW_NUMBERS[0] - 1) * 16) {
      
        //Iterate through tile types
        for(int i=0; i<UndeadInvasion::MapVariables::TILE_ROW_NUMBERS.length; i++) {
        
          //Check relative to current type (row)
          int relativeDifference = oldTileType % ((UndeadInvasion::MapVariables::TILE_ROW_NUMBERS[i] - 1) * 16);
          
          //Check if correct type (row)
          if(relativeDifference < 16) {
          
            //Check if not reduced state
            //TODO: Move reduced state to last 8 tiles: <7
            if(relativeDifference < 6) {
            
              //Reduce state (decrease "health")
              newType = (UndeadInvasion::MapVariables::TILE_ROW_NUMBERS[i] - 1) * 16 + 6; //TODO: +7
              
            }
            
            //Otherwise, already reduced state
            else {
            
              //Check if last state
              if(relativeDifference == 10) { //TODO: == (16-5)
              
                newType = CMap::tile_empty;
                
              }
              
              else {
              
                newType++;
                
              }
              
            }
            
            //Stop checking, right type was found
            break;
            
          }
          
        }
        
      }
      
      return newType;
      
    }
    
    
    
    /**
     * Tile set function
     */
    void onSetTile_(CMap@ this, u32 index, TileType newTileType, TileType oldTileType) {
    
      TileType customType = 0;
      u16 customTileStart = (UndeadInvasion::MapVariables::TILE_ROW_NUMBERS[0] - 1) * 16;
      
      //Check if old tile was custom
      if(oldTileType >= customTileStart) {
        customType = oldTileType;
      }
      
      //Check if new tile is custom and old is not (happens when map is loaded)
      if(newTileType >= customTileStart && oldTileType < customTileStart) {
        customType = newTileType;
      }
      
      //Check if custom tile (don't mess with vanilla stuff)
      if(customType != 0) {
      
        //Iterate through tile types
        for(int i=0; i<UndeadInvasion::MapVariables::TILE_ROW_NUMBERS.length; i++) {
        
          //Check relative to current type (row)
          int relativeDifference = customType % ((UndeadInvasion::MapVariables::TILE_ROW_NUMBERS[i] - 1) * 16);
          
          //Check if correct type (row)
          if(relativeDifference < 16) {
          
            string[] soundFiles;
            
            //Check if last state
            if(relativeDifference == 10) { //TODO: == (16-5)
            
              //Get depleted sounds
              soundFiles = UndeadInvasion::MapVariables::TILE_DEPLETED_SOUND_FILES[i];

            }
            
            //Otherwise, not last state
            else {
            
              //Get harvest sounds
              soundFiles = UndeadInvasion::MapVariables::TILE_HARVEST_SOUND_FILES[i];
              
              //Reset flags
              this.AddTileFlag(index, UndeadInvasion::MapVariables::TILE_FLAGS[i]);
              
            }
            
            //Recall if old is custom (not map load)
            if(oldTileType == customType) {
            
              //Play sound
              Sound::Play(soundFiles[XORRandom(soundFiles.length)], this.getTileWorldPosition(index));
              
            }
            
            //Stop checking, right type was found
            break;
            
          }
          
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