/* 
 * ExampleEntity sprite script
 * 
 * Author: ANybakk
 */

#include "ExampleEntity.as"



//Called on initialization.
void onInit(CSprite@ this) {

  //Obtain blob reference
  CBlob@ blob = this.getBlob();
  
  //Retrieve data
  ExampleEntity::Data@ data = ExampleEntity::Blob::retrieveData(blob);
  
}

//
void onRender(CSprite@ this) {
}

//Called on every tick.
void onTick(CSprite@ this) {
}

//
bool onReceiveCreateData(CSprite@ this, CBitStream@ stream) {
}

//
void onSendCreateData(CSprite@ this, CBitStream@ stream) {
}

//
void onCommand(CSprite@ this, u8 cmd, CBitStream @params) {
}

//
void onGib(CSprite@ this) {
}

//
void onReload(CSprite@ this) {
}