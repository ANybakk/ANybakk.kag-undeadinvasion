/* 
 * Creature blob script
 * 
 * Author: ANybakk
 */

#include "Creature.as"


//Called on initialization.
void onInit(CBlob@ this) {

  //Default data

  Creature::Data data();
  
  Creature::Blob::storeData(this, @data);
  
  //Data modifications
  
  //Initializations

  this.Tag("isCreature");
  
  this.Tag("flesh"); //Vanilla tag that allows being targeted by a bison for instance
  
}