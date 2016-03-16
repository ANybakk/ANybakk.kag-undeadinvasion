/* 
 * ExampleEntity
 * 
 * Author: ANybakk
 */

#include "Entity.as"



namespace ExampleEntity {



  const string NAME = "ExampleEntity";
  
  
  
  shared class Data {
    
    //Options
    
    string                oSomeOption               = "DefaultValue";           //Some option
    
    //EventData (do-once)
    
    Entity::EventData     eSomeDoOnceEvent;
    
    //EventData (do-while)
    
    Entity::EventData     eSomeDoWhileEvent;
    
    //Internals
    
    int                   iSomeVariable;                                        //Some variable
    
  }
  
  
  
  shared class SomeType {
    
    int           someVariable;                                                 //Some variable
  
  }
  
  
  
  namespace SomeMode {


    /**
     * Enumeration for some mode
     */
    enum Mode {
    
      MODE_A = 0
      
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
    
    
    
    /**
     * Does something.
     */
    void doSomething() {
    
      
      
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