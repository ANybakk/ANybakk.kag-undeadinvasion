namespace ANybakk {

  class UndeadInvasionSpawnData {
  
    string mEntityName;
    u8 mSpawnChance;
    
    UndeadInvasionSpawnData() {
    
      mEntityName = "Zombie";
      mSpawnChance = 100;
      
    }
    
    UndeadInvasionSpawnData(string entityName, u8 spawnChance) {
    
      mEntityName = entityName;
      mSpawnChance = spawnChance;
      
    }
    
  }
  
}