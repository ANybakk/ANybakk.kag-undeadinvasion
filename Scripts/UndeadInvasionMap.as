/*
 * UndeadInvasion map
 * 
 * This script takes care of map loading.
 * 
 * Author: ANybakk
 */

#include "UndeadInvasionPNGLoader.as";



/**
 * Loading function
 */
bool LoadMap(CMap@ this, const string& in fileName) {

  print("[UndeadInvasionMap:LoadMap] fileName=" + fileName);

  UndeadInvasionPNGLoader loader();

  return loader.loadMap(this, fileName);
  
}
