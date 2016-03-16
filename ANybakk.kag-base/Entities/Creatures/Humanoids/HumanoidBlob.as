/* 
 * Humanoid blob script
 * 
 * Author: ANybakk
 */

#include "Humanoid.as"
#include "Creature.as"


//Called on initialization.
void onInit(CBlob@ this) {

  //Default data

  Humanoid::Data data();
  Humanoid::Blob::storeData(this, @data);
  
  //Creature data modifications
  
  Creature::Data@ creatureData = Creature::Blob::retrieveData(this);
  creatureData.bBody.oArms = 2;
  creatureData.bBody.oLegs = 2;
  
  //Initializations
  
  this.Tag("isHumanoid");
  
}