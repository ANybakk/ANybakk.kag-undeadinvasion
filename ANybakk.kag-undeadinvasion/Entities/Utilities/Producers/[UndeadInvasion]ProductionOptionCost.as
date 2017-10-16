


namespace UndeadInvasion {

  class ProductionOptionCost {
  
  
  
    string  mCaption;
    string  mName;      //Icon token should match
    u8      mAmount;
    bool    mOptional;
    bool    mConsumed;
    
    
    
    ProductionOptionCost() {
    
      mCaption = "Wood";
      mName = "mat_wood";
      mAmount = 10;
      mOptional = false;
      mConsumed = true;
      
    }
    
    
    
    ProductionOptionCost(string caption, string name, u8 amount, bool optional=false, bool consumed=true) {
    
      mCaption = caption;
      mName = name;
      mAmount = amount;
      mOptional = optional;
      mConsumed = consumed;
      
    }
    
    
    
    ProductionOptionCost(CBitStream@ stream) {
    
      if(!stream.saferead_string(mCaption)) {
        mCaption = "Wood";
      }
    
      if(!stream.saferead_string(mName)) {
        mName = "mat_wood";
      }
    
      if(!stream.saferead_u8(mAmount)) {
        mAmount = 10;
      }
    
      if(!stream.saferead_bool(mOptional)) {
        mOptional = false;
      }
    
      if(!stream.saferead_bool(mConsumed)) {
        mConsumed = true;
      }
      
    }
    
    
    
    void toStream(CBitStream@ stream) {
      
      stream.write_string(mCaption);
      stream.write_string(mName);
      stream.write_u8(mAmount);
      stream.write_bool(mOptional);
      stream.write_bool(mConsumed);
      
    }
    
    
    
    string toString() {
      
      return
        "mCaption:"     + mCaption
        + " mName:"     + mName
        + " mAmount:"   + mAmount
        + " mOptional:" + mOptional
        + " mConsumed:" + mConsumed;
      
    }
    
    
    
  }
  
}