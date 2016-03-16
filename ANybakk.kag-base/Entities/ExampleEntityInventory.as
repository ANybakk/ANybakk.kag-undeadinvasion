/* 
 * ExampleEntity inventory script
 * 
 * Author: ANybakk
 */

#include "ExampleEntity.as"



//Called on initialization.
void onInit(CInventory@ this) {

  //Obtain blob reference
  CBlob@ blob = this.getBlob();
  
  //Retrieve data
  ExampleEntity::Data@ data = ExampleEntity::Blob::retrieveData(blob);
  
}

//Called on every tick.
void onTick(CInventory@ this) {
}

//
bool onReceiveCreateData(CInventory@ this, CBitStream@ stream) {
}

//
void onSendCreateData(CInventory@ this, CBitStream@ stream) {
}

//
void onCommand(CInventory@ this, u8 cmd, CBitStream @params) {
}

//
void onCreateInventoryMenu(CInventory@ this, CBlob@ forBlob, CGridMenu @gridmenu) {
}