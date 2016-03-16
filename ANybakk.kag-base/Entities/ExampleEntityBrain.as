/* 
 * ExampleEntity brain script
 * 
 * Author: ANybakk
 */

#include "ExampleEntity.as"



//Called on initialization.
void onInit(CBrain@ this) {

  //Obtain blob reference
  CBlob@ blob = this.getBlob();
  
  //Retrieve data
  ExampleEntity::Data@ data = ExampleEntity::Blob::retrieveData(blob);
  
}

//Called on every tick.
void onTick(CBrain@ this) {
}

//
bool onReceiveCreateData(CBrain@ this, CBitStream@ stream) {
}

//
void onSendCreateData(CBrain@ this, CBitStream@ stream) {
}

//
void onCommand(CBrain@ this, u8 cmd, CBitStream @params) {
}

//
void onPlannerSolution(CBrain@ this) {
}