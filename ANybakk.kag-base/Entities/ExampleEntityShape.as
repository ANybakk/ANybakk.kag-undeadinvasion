/* 
 * ExampleEntity shape script
 * 
 * Author: ANybakk
 */

#include "ExampleEntity.as"



//Called on initialization.
void onInit(CShape@ this) {

  //Obtain blob reference
  CBlob@ blob = this.getBlob();
  
  //Retrieve data
  ExampleEntity::Data@ data = ExampleEntity::Blob::retrieveData(blob);
  
}

//Called on every tick.
void onTick(CShape@ this) {
}

//
bool onReceiveCreateData(CShape@ this, CBitStream@ stream) {
}

//
void onSendCreateData(CShape@ this, CBitStream@ stream) {
}

//
void onCommand(CShape@ this, u8 cmd, CBitStream @params) {
}