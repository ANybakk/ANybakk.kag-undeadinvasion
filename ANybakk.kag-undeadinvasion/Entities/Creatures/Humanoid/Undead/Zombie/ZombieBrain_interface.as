/*
 * Zombie brain interface.
 
 * Author: ANybakk
 */

#define SERVER_ONLY



#include "UndeadBrain.as";
//#include "UndeadVariables.as";

UndeadBrain cUndeadBrain;



void onInit(CBrain@ this) {

  cUndeadBrain.onInit(this);
  
}

void onTick(CBrain@ this) {

  cUndeadBrain.onTick(this);

}