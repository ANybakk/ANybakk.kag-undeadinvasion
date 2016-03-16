/* 
 * ExampleEntity movement script
 * 
 * Author: ANybakk
 */

#include "ExampleEntity.as"



//Called on initialization.
void onInit(CMovement@ this) {

  //Obtain blob reference
  CBlob@ blob = this.getBlob();
  
  //Retrieve data
  ExampleEntity::Data@ data = ExampleEntity::Blob::retrieveData(blob);
  
}

//Called on every tick.
void onTick(CMovement@ this) {
}

//
bool onReceiveCreateData(CMovement@ this, CBitStream@ stream) {
}

//
void onSendCreateData(CMovement@ this, CBitStream@ stream) {
}

//
void onCommand(CMovement@ this, u8 cmd, CBitStream @params) {
}