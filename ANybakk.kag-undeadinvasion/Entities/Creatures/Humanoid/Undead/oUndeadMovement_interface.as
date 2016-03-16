/*
 * Undead movement interface.
 * 
 * Author: ANybakk
 */

#define SERVER_ONLY



#include "UndeadMovement.as";
//#include "UndeadVariables.as";

UndeadMovement cUndeadMovement;



void onInit(CMovement@ this) {

  cUndeadMovement.onInit(this);
  
}

void onTick(CMovement@ this) {

  cUndeadMovement.onTick(this);
  
}