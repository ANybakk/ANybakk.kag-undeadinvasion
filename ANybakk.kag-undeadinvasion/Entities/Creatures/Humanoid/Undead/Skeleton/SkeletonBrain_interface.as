/*
 * Skeleton brain interface.
 
 * Author: ANybakk
 */

#define SERVER_ONLY



#include "UndeadBrain.as";
#include "SkeletonUndeadVariables.as" //Derived from UndeadVariables

SkeletonUndeadVariables vSkeletonUndeadVariables;

UndeadBrain cUndeadBrain(vSkeletonUndeadVariables);



void onInit(CBrain@ this) {

  cUndeadBrain.onInit(this);
  
}

void onTick(CBrain@ this) {

  cUndeadBrain.onTick(this);

}