
void onInit(CBlob@ this)
{
  //UndeadInvasion
  //this.maxQuantity = 250;
  this.maxQuantity = 60;

  this.getCurrentScript().runFlags |= Script::remove_after_this;
}
