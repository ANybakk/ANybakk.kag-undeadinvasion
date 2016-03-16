/*
 * UndeadInvasion map interface.
 * 
 * Author: ANybakk
 */

#include "UndeadInvasionMap.as";



bool LoadMap(CMap@ this, const string& in fileName) {

  return UndeadInvasionMap::LoadMap(this, fileName);
  
}