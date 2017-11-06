/*
 * UndeadInvasion rules script interface
 * 
 * Author: ANybakk
 */
 
#define SERVER_ONLY

#include "[UndeadInvasion]Rules.as";



void onInit(CRules@ this) {

  UndeadInvasion::Rules::onInit(this);
  
}

void onRestart(CRules@ this) {

  UndeadInvasion::Rules::onRestart(this);
  
}

void onStateChange(CRules@ this, const u8 oldState) {

  UndeadInvasion::Rules::onStateChange(this, oldState);
  
}

void onTick(CRules@ this) {

  UndeadInvasion::Rules::onTick(this);
  
}