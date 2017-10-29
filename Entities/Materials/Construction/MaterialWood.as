
void onInit(CBlob@ this)
{
  if (getNet().isServer())
  {
    this.set_u8('decay step', 18);
  }

  //UndeadInvasion
  //this.maxQuantity = 250;
  this.maxQuantity = 60;

  this.getCurrentScript().runFlags |= Script::remove_after_this;
}
