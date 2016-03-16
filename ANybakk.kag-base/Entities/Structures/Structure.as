/* 
 * Structure
 * 
 * Author: ANybakk
 */

namespace Structure {



  const string NAME = "Structure";
  
  
  
  shared class Data {
    
    //Options
    
    int                   oBackgroundTileType       = CMap::tile_wood_back;     //Background tile type. Default: wooden background.
    string                oPlacementSound           = "";                       //Sound played when placed. Default: blank (disabled).
    
    //EventData (do-once)
    
    //EventData (do-while)
    
    //Internals
    
    u16                   iOrientation              = Structure::BlobOrientation::ORIENTATION_UP;
    bool                  iWasPlaced                = false;
    bool                  iIsPlaced                 = false;
    bool                  iWasDestroyed             = false;
    bool                  iWasRemoved               = false;
    
  }
  
  
  
  namespace BlobOrientation {
  
  
  
    /**
     * Enumeration for orientation (angle).
     * NOTE: u8 is not large enough to hold this data.
     */
    enum Orientation {
  
      ORIENTATION_UP    =   0,
      ORIENTATION_RIGHT =  90,
      ORIENTATION_DOWN  = 180,
      ORIENTATION_LEFT  = 270
      
    }
    
    
    
  }
  
  
  
  namespace Blob {
  
  
  
    /**
     * Stores a data object
     * 
     * @param   this    a blob pointer.
     * @param   data     a data pointer.
     */
    void storeData(CBlob@ this, Data@ data = null) {

      if(data is null) {
      
        @data = Data();
        
      }
      
      this.set(NAME + "::Data", @data);
      
    }
    
    
    
    /**
     * Retrieves a data object.
     * 
     * @param   this    a blob pointer.
     * @return  data     a pointer to the data (null if none was found).
     */
    Data@ retrieveData(CBlob@ this) {
    
      Data@ data;
      
      this.get(NAME + "::Data", @data);
      
      return data;
      
    }
    
    
    
  }
  
  
  
  namespace Sprite {
  
  
  
    /**
     * Updates animation frame depending on current orientation. Useful in 
     * cases where standard rotation of sprite is not desired. Only affect 
     * placed blobs. Animation frames in clockwise order, starting with UP.
     * 
     * @param   variants   the number of variants supported (2 or 4)
     */
    void updateFrameFromOrientation(CSprite@ this, int variants=4) {
      
      //Obtain a reference to the blob object
      CBlob@ blob = this.getBlob();
      
      //Retrieve data
      Structure::Data@ data = Structure::Blob::retrieveData(blob);
      
      //Check if segment was recently placed
      if(data.iWasPlaced) {
        
        //Check if orientation is up
        if(data.iOrientation == Structure::BlobOrientation::ORIENTATION_UP) {
        
          //Set frame to 0
          this.animation.frame = 0;
          
        }
        
        //Check if orientation is right
        else if(data.iOrientation == Structure::BlobOrientation::ORIENTATION_RIGHT) {
        
          //Set frame to 1
          this.animation.frame = 1;
          
        }
        
        //Check if orientation is down
        else if(data.iOrientation == Structure::BlobOrientation::ORIENTATION_DOWN) {
        
          if(variants == 2) {
          
            //Set frame to 0
            this.animation.frame = 0;
            
          } else {
          
            //Set frame to 2
            this.animation.frame = 2;
            
          }
          
        }
        
        //Check if orientation is left
        else if(data.iOrientation == Structure::BlobOrientation::ORIENTATION_LEFT) {
        
          if(variants == 2) {
          
            //Set frame to 1
            this.animation.frame = 1;
            
          } else {
          
            //Set frame to 3
            this.animation.frame = 3;
            
          }
          
        }
        
        //Reset angle
        blob.getShape().SetAngleDegrees(0.0f);
        
      }
      
      //Finished
      return;
      
    }
    
    
    
  }
  
  
  
}