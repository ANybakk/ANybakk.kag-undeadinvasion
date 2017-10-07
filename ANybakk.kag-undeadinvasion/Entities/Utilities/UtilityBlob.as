/* 
 * Utility blob
 * 
 * Author: ANybakk
 */

#include "Blob.as";



namespace UndeadInvasion {

  namespace UtilityBlob {
  
  
  
    /**
     * Initializes this entity
     */
    void onInit(CBlob@ this) {
      
      UndeadInvasion::Blob::onInit(this);
      
      setTags(this);
      setCommands(this);
      setHarvestMaterials(this);
      
    }
  
    
    
    /**
     * Sets various tags for this entity type. Inheriting types should call this.
     * 
     * @param   this            a blob reference.
     */
    void setTags(CBlob@ this) {
    
      this.Tag("isUtilityBlob");
      
      this.Tag("builder always hit"); //BuilderHittable.as: Required for builder to be able to hit it.
      
    }
    
    
    
    /**
     * Sets various commands for this entity type.
     * 
     * @param   this            a blob reference.
     */
    void setCommands(CBlob@ this) {
    
      //this.addCommandID("commandName");
      //AddIconToken("$commandName$", "InteractionIcons.png", Vec2f(32, 32), 0); //Icon number 1
      
    }
    
    
    
    /**
     * Sets what materials are returned when harvesting
     */
    void setHarvestMaterials(CBlob@ this) {
    
      //Replace with derivative of BlobBuildBlock
      //this.set("harvest", BlobBuildBlock().mHarvestMaterials);
      
    }
    
    
    
    void onSetStatic(CBlob@ this, const bool isStatic) {
    
      if(UtilityVariables::REMOVE_GRASS) {
      
        clearGrass(this);
        
      }
      
    }
    
    
    
    /**
     * Clears any grass tiles
     * 
     * @param   this            a blob reference.
     */
    void clearGrass(CBlob@ this) {
      
      CShape@ shape = this.getShape();
      CMap@ map = this.getMap();
      
      if(shape !is null && map !is null) {
      
        Vec2f topLeftPosition;
        Vec2f bottomRightPosition;
        
        //Get positional data for the shape
        shape.getBoundingRect(topLeftPosition, bottomRightPosition);
        
        //If only there was a CMap.getTilesInBox function
        
        //Obtain width
        f32 width = this.getWidth();
        
        //Calculate any excess width in case width isn't divisible by tile size
        f32 excessWidth = width % map.tilesize;
        
        //Figure out the position of the last (bottom right) tile by adjusting for excess width and tile size
        bottomRightPosition += Vec2f((map.tilesize + excessWidth) / -2.0f, map.tilesize / -2.0f);
        
        Tile tile;
        
        //Iterate for every whole tile
        for(int i=0; i<Maths::Floor(width / map.tilesize); i++) {
        
          //Get tile
          tile = map.getTile(bottomRightPosition);
          
          //Check if grass
          if(map.isTileGrass(tile.type)) {
          
            //Set empty instead
            map.server_SetTile(bottomRightPosition, CMap::tile_empty);
            
          }
          
          //Calculate next position
          bottomRightPosition.x -= map.tilesize;
          
        }
        
      }
      
    }
    
    
    
  }
  
}