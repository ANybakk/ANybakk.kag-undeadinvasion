/* 
 * This script holds everything associated with the blob aspect of the Humanoid 
 * entity. That excludes things related to AI brains, AI movement etc.
 * 
 * Author: ANybakk
 */

#include "CreatureBlob.as";



namespace UndeadInvasion {

  namespace HumanoidBlob {
  
  
  
    /**
     * Initializes this entity
     */
    void doInit(CBlob@ this) {
      
      UndeadInvasion::CreatureBlob::doInit(this);
      
      setTags(this);
      
    }
  
    
    
    /**
     * Sets various tags for this entity type. Inheriting types should call this.
     * 
     * @param   this            a blob reference.
     */
    void setTags(CBlob@ this) {
      
      this.Tag("isMadeOfBones");
      this.Tag("hasLimbs");
      this.Tag("hasArms");
      this.Tag("hasLegs");
      this.Tag("hasEyes");
      
    }
  
  
  
      
    /**
     * Retrieves the positions for all neighbouring tiles.
     * Tiles are indexed clock-wise, starting from the top left.
     * 
     * @param   this    a reference to the blob object.
     * @returns         a 2D array of vectors representing all the possible tile positions.
     */
    Vec2f[][] getNeighbourTilePositions(CBlob@ this) {

      //Create the array
      Vec2f[][] result;
      
      //Get the blob's position
      Vec2f currentPosition = this.getPosition();
      
      //Get the blob's radius
      f32 radius = this.getRadius();
      
      //Retrieve the map's tile size setting
      u8 tileSize = this.getMap().tilesize;
      
      {
      
        Vec2f[] over;
      
        //Determine over left position (horizontal distance is half tile size, vertical distance is radius plus half tile size)
        over.push_back(currentPosition + Vec2f(0.0f - tileSize/2, -(radius+tileSize/2)));
        
        //Determine over right position
        over.push_back(currentPosition + Vec2f(0.0f + tileSize/2, -(radius+tileSize/2)));
        
        result.push_back(over);
        
      }
      
      {
      
        Vec2f[] right;
        
        //Determine right upper position
        right.push_back(currentPosition + Vec2f(radius+tileSize/2, 0.0f - tileSize/2));
      
        //Determine right lower position
        right.push_back(currentPosition + Vec2f(radius+tileSize/2, 0.0f + tileSize/2));
        
        result.push_back(right);
        
      }
      
      {
      
        Vec2f[] under;
        
        //Determine under right position
        under.push_back(currentPosition + Vec2f(0.0f + tileSize/2, radius+tileSize/2));
      
        //Determine under left position
        under.push_back(currentPosition + Vec2f(0.0f - tileSize/2, radius+tileSize/2));
        
        result.push_back(under);
        
      }
      
      {
      
        Vec2f[] left;
      
        //Determine left lower position (horizontal distance is radius plus half tile size, vertical distance is half tile size)
        left.push_back(currentPosition + Vec2f(-(radius+tileSize/2), 0.0f + tileSize/2));
        
        //Determine left upper position
        left.push_back(currentPosition + Vec2f(-(radius+tileSize/2), 0.0f - tileSize/2));
        
        result.push_back(left);
        
      }
      
      //Finished, return result
      return result;
      
    }
    
    
    
  }
  
}