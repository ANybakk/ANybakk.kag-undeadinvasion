#include "[UndeadInvasion]Map.as";



void onHitMap(CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, u8 customData) {

  CMap@ map = getMap();
  
  if(map !is null) {
  
    TileType oldType = map.getTile(worldPoint).type;
    TileType newType = UndeadInvasion::Map::onTileHit(map, damage, oldType);
    
    if(newType != oldType) {
    
      //TODO: Check if custom type, and what type it is
      
      CSprite@ sprite = this.getSprite();
      
      if(sprite !is null) {
        sprite.PlaySound("dig_stone1.ogg");
      }
      
    }
    
  }
  
}