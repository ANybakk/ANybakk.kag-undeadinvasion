void onInit(CBlob@ this) {

  this.maxQuantity = 1;

  this.getCurrentScript().runFlags |= Script::remove_after_this;
  
}
