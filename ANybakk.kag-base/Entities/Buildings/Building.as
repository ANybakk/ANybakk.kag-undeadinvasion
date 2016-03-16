/* 
 * Building
 * 
 * Author: ANybakk
 */

namespace Building {



  const string NAME = "Building";
  
  
  
  shared class Data {
    
    //Options
    
    u16                   oBackWallType             = CMap::tile_wood_back;             //Background tile type
    bool                  oHasWindow                = true;                             //If there should be a window in the background
    
    //EventData (do-once)
    
    //EventData (do-while)
    
    //Internals
    
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
  }
  
  
  
  namespace Shape {
  }
  
  
  
  namespace Movement {
  }
  
  
  
  namespace Brain {
  }
  
  
  
  namespace Attachment {
  }
  
  
  
  namespace Inventory {
  }
  
  
  
}