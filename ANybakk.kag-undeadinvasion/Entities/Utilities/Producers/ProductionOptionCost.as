


namespace UndeadInvasion {

  class ProductionOptionCost {
  
  
  
    string  mCaption;
    string  mName; //Icon token should match
    u8      mAmount;
    
    
    
    ProductionOptionCost() {
    
      mCaption = "Wood";
      mName = "mat_wood";
      mAmount = 10;
      
    }
    
    
    
    ProductionOptionCost(string caption, string name, u8 amount) {
    
      mCaption = caption;
      mName = name;
      mAmount = amount;
      
    }
    
    
    
  }
  
}