/* 
 * ExampleEntity attachment script
 * 
 * Author: ANybakk
 */

#include "ExampleEntity.as"



//Called on initialization.
void onInit(CAttachment@ this) {

  //Obtain blob reference
  CBlob@ blob = this.getBlob();
  
  //Retrieve data
  ExampleEntity::Data@ data = ExampleEntity::Blob::retrieveData(blob);
  
}

//Called on every tick.
void onTick(CAttachment@ this) {
}

//
bool onReceiveCreateData(CAttachment@ this, CBitStream@ stream) {
}

//
void onSendCreateData(CAttachment@ this, CBitStream@ stream) {
}

//
void onCommand(CAttachment@ this, u8 cmd, CBitStream @params) {
}