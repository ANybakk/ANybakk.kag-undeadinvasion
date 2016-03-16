/*
 * Game rules script
 * 
 * Author: ANybakk
 */



//Called on initialization.
void onInit(CRules@ this) {
  
  //Save start time
  this.set_u32("Rules::startTime", getGameTime());
  
  //Finished
  return;
  
}



//Called on restart.
void onRestart(CRules@ this) {
  
  //Finished
  return;
  
}