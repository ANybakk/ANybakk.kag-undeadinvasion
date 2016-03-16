/*
 * Skeleton sprite interface.
 * 
 * Author: ANybakk
 */

#include "EntitySprite.as"
//#include "EntityVariables.as"

EntitySprite cEntitySprite;



#include "UndeadSprite.as";
#include "SkeletonUndeadVariables.as" //Derived from UndeadVariables

SkeletonUndeadVariables vSkeletonUndeadVariables;

UndeadSprite cUndeadSprite(vSkeletonUndeadVariables);



void onInit(CSprite@ this) {

  cEntitySprite.onInit(this);

  cUndeadSprite.onInit(this);
  
}

void onTick(CSprite@ this) {

  cEntitySprite.onTick(this);

  cUndeadSprite.onTick(this);
  
}

void onRender(CSprite@ this) {

  cUndeadSprite.onRender(this);
  
}

