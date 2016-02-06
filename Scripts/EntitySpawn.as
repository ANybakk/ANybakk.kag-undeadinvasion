namespace UndeadInvasion {

  class EntitySpawn {
  
    string mEntityName;
    u8 mSpawnChance;
    
    EntitySpawn() {
    
      mEntityName = "Zombie";
      mSpawnChance = 100;
      
    }
    
    EntitySpawn(string entityName, u8 spawnChance) {
    
      mEntityName = entityName;
      mSpawnChance = spawnChance;
      
    }
    
  }
  
}