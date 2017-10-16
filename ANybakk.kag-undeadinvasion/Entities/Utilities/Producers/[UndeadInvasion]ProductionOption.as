#include "[UndeadInvasion]ProductionOptionCost.as";



namespace UndeadInvasion {

  class ProductionOption {
  
  
  
    string                  mCaption;
    string                  mName;        //Icon token should match
    string                  mDescription;
    u8                      mTime;
    ProductionOptionCost@[] mCosts;
    
    
    
    ProductionOption() {
    
      mCaption = "Lantern";
      mName = "lantern";
      mDescription = "Keeps ghosts away";
      ProductionOptionCost cost("Wood", "mat_wood", 10);
      mCosts.push_back(cost);
      mTime = 1;
      
    }
    
    
    
    ProductionOption(string caption, string name, string description, u8 time, ProductionOptionCost@[] costs) {
    
      mCaption = caption;
      mName = name;
      mDescription = description;
      mTime = time;
      mCosts = costs;
      
    }
    
    
    
    ProductionOption(CBitStream@ stream) {
    
      if(!stream.saferead_string(mCaption)) {
        mCaption = "Lantern";
      }
    
      if(!stream.saferead_string(mName)) {
        mName = "lantern";
      }
    
      if(!stream.saferead_string(mDescription)) {
        mDescription = "Keeps ghosts away";
      }
    
      if(!stream.saferead_u8(mTime)) {
        mTime = 1;
      }
      
      while(!stream.isBufferEnd()) {
      
        mCosts.push_back(ProductionOptionCost(stream));
        
      }
      
    }
    
    
    
    void toStream(CBitStream@ stream, bool traverse=false) {
      
      stream.write_string(mCaption);
      stream.write_string(mName);
      stream.write_string(mDescription);
      stream.write_u8(mTime);
      
      if(traverse) {
      
        for(int i=0; i<mCosts.length; i++) {
        
          mCosts[i].toStream(stream);
          
        }
        
      }
      
    }
    
    
    
    string toString(bool traverse=false) {
      
      string output =
          "mCaption:"       + mCaption
        + " mName:"         + mName
        + " mDescription:"  + mDescription
        + " mTime:"         + mTime;
      
      if(traverse) {
      
        for(int i=0; i<mCosts.length; i++) {
        
          output += " mCosts[" + i + "]: {" + mCosts[i].toString() + "}";
          
        }
        
      }
      
      return output;
      
    }
    
    
    
  }
  
}