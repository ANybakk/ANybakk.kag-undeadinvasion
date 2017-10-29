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

TileType server_onTileHit(CMap@ this, f32 damage, u32 index, TileType oldTileType) {

  return UndeadInvasion::Map::server_onTileHit(this, damage, index, oldTileType);
  
}

void onSetTile(CMap@ this, u32 index, TileType newtile, TileType oldtile) {

  UndeadInvasion::Map::onSetTile_(this, index, newtile, oldtile);
  
}