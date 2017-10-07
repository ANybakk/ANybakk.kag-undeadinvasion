/*
 * UndeadInvasion map interface
 * 
 * Author: ANybakk
 */

#include "[UndeadInvasion]Map.as";



void onInit(CMap@ this) {

  UndeadInvasion::Map::onInit(this);
  
}

bool LoadMap(CMap@ this, const string& in fileName) {

  return UndeadInvasion::Map::LoadMap(this, fileName);
  
}

void onTick(CMap@ this) {

  UndeadInvasion::Map::onTick(this);
  
}