/*
 * UndeadInvasion re-spawn system
 * 
 * This script handles anything related to player/survivor spawning.
 * Players are spawned at survivor spawns, or in the middle of the map if no
 * spawn exists. Players are kept in a simple queue until they can spawn, which 
 * is during day-time. If the game is in warm-up mode, the game will start when 
 * a player/survivor is spawned.
 * 
 * Author: ANybakk
 * Based on previous work by: Eanmig
 */

#include "RulesCore.as";
#include "RespawnSystem.as";



/**
 * UndeadInvasionRespawnSystem
 * Represents the re-spawn functionality
 */
shared class UndeadInvasionRespawnSystem : RespawnSystem {


  
  //Keep a record of info objects for players waiting to spawn
  PlayerInfo@[] mPlayerInfoSpawnQueue;
  
  
  
  /**
   * Links a rules core to this respawn system
   */
	void SetCore(RulesCore@ rulesCore) override {
  
    //Call super class' version of this method
		RespawnSystem::SetCore(rulesCore);
    
    //Finished
    
	}
  
  
  
  /**
   * Performs an update
   */
  void Update() override {

    //if(g_debug > 0) { print("[UndeadInvasionRespawnSystem:Update]"); }
      
    //Create a handle to player info object
    PlayerInfo@ playerInfo;
    
    //Iterate through all team spawns
    for (int i = 0; i < mPlayerInfoSpawnQueue.length; i++) {
    
      //Save reference to player info
      @playerInfo = mPlayerInfoSpawnQueue[i];
      
      //Spawn player
      DoSpawnPlayer(@playerInfo);
      
    }
    
    //Finished
    return;
    
  }
  
  
  
  /**
   * Adds a player to the spawn queue
   */
  void AddPlayerToSpawn(CPlayer@ player) override {

    if(g_debug > 0) { print("[UndeadInvasionRespawnSystem:AddPlayerToSpawn]"); }
    
    //Retrieve a reference to the info object for the player
    PlayerInfo@ playerInfo = core.getInfoFromPlayer(player);
    
    //Check if player info object is missing
    if(playerInfo is null) {
    
      return;
    
    }
    
    //Add player object to the spawn queue
    mPlayerInfoSpawnQueue.push_back(playerInfo);
    
    //Finished
    return;
    
  }
  
  
  
  /**
   * Adds a player to the spawn queue
   */
	void RemovePlayerFromSpawn(CPlayer@ player) override {

    if(g_debug > 0) { print("[UndeadInvasionRespawnSystem:RemovePlayerFromSpawn]"); }
    
    //Retrieve a reference to the info object for the player
    PlayerInfo@ playerInfo = core.getInfoFromPlayer(player);
    
    //Check if player info object is missing
    if(playerInfo is null) {
    
      return;
    
    }
    
    //Locate the player in the spawn queue
    int playerQueuePosition = mPlayerInfoSpawnQueue.find(playerInfo);
    
    //Check if the player was in the queue
		if(playerQueuePosition != -1) {
    
      //Remove the player from the queue
			mPlayerInfoSpawnQueue.erase(playerQueuePosition);
      
		}
    
    //Finished
    return;
  
  }
  
  
  
  /**
   * Checks whether a player is in the spawn queue or not
   */
  bool isSpawning(CPlayer@ player) override {

    //if(g_debug > 0) { print("[UndeadInvasionRespawnSystem:isSpawning]"); }
    
    //Retrieve a reference to the info object for the player
    PlayerInfo@ playerInfo = core.getInfoFromPlayer(player);
    
    //Finished, return true if in queue
		return mPlayerInfoSpawnQueue.find(playerInfo) != -1;
    
	}
  
  
  
  /**
   * Spawns a player
   */
  void DoSpawnPlayer(PlayerInfo@ playerInfo) override {

    //if(g_debug > 0) { print("[UndeadInvasionRespawnSystem:DoSpawnPlayer]"); }
    
    BaseTeamInfo teamInfo = core.teams[playerInfo.team];
    
    if(teamInfo.name == "Undead team") {
    
      //Set blob type to be Zombie
      //TODO: New player-controlled Zombie type
      //TODO: Randomize type of undead or stronger type
      playerInfo.blob_name = "Zombie";
    
    }
    
    else {
    
      //Set blob type to be builder
      playerInfo.blob_name = "builder";
      
    }
    
    //Call super class' version of this method
    RespawnSystem::DoSpawnPlayer(playerInfo);
    
    //Finished
    return;
  
  }
  
  
  
  /**
   * Checks if a player can be spawned
   */
  bool canSpawnPlayer(PlayerInfo@ playerInfo) override {

    //if(g_debug > 0) { print("[UndeadInvasionRespawnSystem:canSpawnPlayer]"); }
  
    //Check if player info is not valid
    if(playerInfo is null) {
    
      return false; 
      
    }
    
    //Finished, return true if not night time
    return !cast<UndeadInvasionRulesCore@>(core).isNightTime();
    
  }
  
  
  
  /**
   * Provides a spawn location
   * TODO: Handle different teams
   */
  Vec2f getSpawnLocation(PlayerInfo@ playerInfo) override {

    //if(g_debug > 0) { print("[UndeadInvasionRespawnSystem:getSpawnLocation]"); }
    
    //Retrieve a reference to the map object
    CMap@ map = getMap();
    
    //Create an array of handles for survivor spawns
    CBlob@[] survivorSpawns;
    
    //Check that we have a valid map object reference
    if(map !is null) {
   
      //Retrieve a reference to any survivor spawn blobs
      getBlobsByName("SurvivorCamp", @survivorSpawns);
      
      //Check if at least one spawn exist
      if(survivorSpawns.length > 0) {
      
        //Return the location of a random survivor spawn (assumed game time dependant)
        return survivorSpawns[XORRandom(survivorSpawns.length)].getPosition();
      
      }
      
      //Check if no spawns exists
      else {
      
        //Calculate the x-coordinate for the middle of the map
        f32 xLocation = map.tilemapwidth * map.tilesize / 2;
        
        //Get the y-coordinate
        f32 yLocation = map.getLandYAtX(s32(xLocation/map.tilesize)) * map.tilesize - 16.0f;
        
        //Return location
        return Vec2f(xLocation, yLocation);
        
      }
      
    }
    
    //Finished
    return Vec2f(0,0);
    
  }
  
}