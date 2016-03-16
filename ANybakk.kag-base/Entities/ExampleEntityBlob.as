/* 
 * ExampleEntity blob script
 * 
 * Author: ANybakk
 */

#include "ExampleEntity.as"



//Called on initialization.
void onInit(CBlob@ this) {

  //Default data

  ExampleEntity::Data data();
  ExampleEntity::Blob::storeData(this, @data);
  
  //Data modifications
  
  //Initializations
  
  this.Tag("is" + "ExampleEntity");
  
}

//Called on every tick.
void onTick(CBlob@ this) {
  
  //Retrieve data
  ExampleEntity::Data@ data = ExampleEntity::Blob::retrieveData(this);
  
}

//
bool onReceiveCreateData(CBlob@ this, CBitStream@ stream) {
}

//
void onSendCreateData(CBlob@ this, CBitStream@ stream) {
}

//
bool onReceiveDelta(CBlob@ this, CBitStream@ stream) {
}

//
void onSendDelta(CBlob@ this, CBitStream@ stream) {
}

//Called on death/destruction.
void onDie(CBlob@ this) {
}

//Called on collision check.
bool doesCollideWithBlob(CBlob@ this, CBlob@ blob) {
}

//Called on collision.
void onCollision(CBlob@ this, CBlob@ blob, bool solid) {
}

//Called on collision.
void onCollision(CBlob@ this, CBlob@ blob, bool solid, Vec2f normal) {
}

//Called on collision.
void onCollision(CBlob@ this, CBlob@ blob, bool solid, Vec2f normal, Vec2f point1) {
}

//Called on collision.
void onCollision(CBlob@ this, CBlob@ blob, bool solid, Vec2f normal, Vec2f point1, Vec2f point2) {
}

//
void onEndCollision(CBlob@ this, CBlob@ blob) {
}

//
void onCommand(CBlob@ this, u8 cmd, CBitStream @params) {
}

//Called on every hit.
f32 onHit(CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitterBlob, u8 customData) {
}

//
void onHitBlob(CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitBlob, u8 customData) {
}

//
void onHitMap(CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, u8 customData) {
}

//
void onCreateInventoryMenu(CBlob@ this, CBlob@ forBlob, CGridMenu @gridmenu) {
}

//
void onAddToInventory(CBlob@ this, CBlob@ blob) {
}

//
void onThisAddToInventory(CBlob@ this, CBlob@ inventoryBlob) {
}

//
void onRemoveFromInventory(CBlob@ this, CBlob@ blob) {
}

//
void onThisRemoveFromInventory(CBlob@ this, CBlob@ inventoryBlob) {
}

//
bool canBePutInInventory(CBlob@ this, CBlob@ inventoryBlob) {
}

//
void onQuantityChange(CBlob@ this, int oldQuantity) {
}

//
void onHealthChange(CBlob@ this, f32 oldHealth) {
}

//
void onAttach(CBlob@ this, CBlob@ attached, AttachmentPoint @attachedPoint) {
}

//
void onDetach(CBlob@ this, CBlob@ detached, AttachmentPoint@ attachedPoint) {
}

//Called on pickup check.
bool canBePickedUp(CBlob@ this, CBlob@ byBlob) {
}

//
void GetButtonsFor(CBlob@ this, CBlob@ caller) {
}

//
bool isInventoryAccessible(CBlob@ this, CBlob@ forBlob) {
}

//
void onChangeTeam(CBlob@ this, const int oldTeam) {
}

//
void onClickedBubble(CBlob@ this, int index) {
}

//
void onSetStatic(CBlob@ this, const bool isStatic) {
}

//
void onReload(CBlob@ this) {
}

//
void onLowLevelNode(CBlob@ this, CBlob@ blob, bool solid) {
}

//
void onSetPlayer(CBlob@ this, CPlayer@ player) {
}