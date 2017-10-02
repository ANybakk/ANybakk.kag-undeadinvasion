#include "ProductionOptionCost.as";



namespace UndeadInvasion {

  class ProductionOption {
  
  
  
    string                  mCaption;
    string                  mName; //Icon token should match
    string                  mDecription;
    ProductionOptionCost@[] mCosts;
    u8                      mTime;
    
    
    
    ProductionOption() {
    
      mCaption = "Lantern";
      mName = "lantern";
      mDecription = "Keeps ghosts away";
      ProductionOptionCost cost("Wood", "mat_wood", 10);
      mCosts.push_back(cost);
      mTime = 1;
      
    }
    
    
    
    ProductionOption(string caption, string name, string description, ProductionOptionCost@[] costs, u8 time) {
    
      mCaption = caption;
      mName = name;
      mDecription = description;
      mCosts = costs;
      mTime = time;
      
    }
    
    
    
  }
  
}