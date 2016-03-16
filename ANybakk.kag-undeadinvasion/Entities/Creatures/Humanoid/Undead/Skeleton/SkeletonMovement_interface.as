/*
 * Skeleton movement interface.
 * 
 * Author: ANybakk
 */

#define SERVER_ONLY



#include "UndeadMovement.as";
#include "SkeletonUndeadVariables.as" //Derived from UndeadVariables

SkeletonUndeadVariables vSkeletonUndeadVariables;

UndeadMovement cUndeadMovement(vSkeletonUndeadVariables);



void onInit(CMovement@ this) {

  cUndeadMovement.onInit(this);
  
}

void onTick(CMovement@ this) {

  cUndeadMovement.onTick(this);
  
}