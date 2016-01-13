/*
 * UndeadInvasion re-spawn system
 * 
 * Author: ANybakk
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
	void SetCore(RulesCore@ rulesCore) {
  
    //Call super class' version of this method
		RespawnSystem::SetCore(rulesCore);
    
    //Finished
    
	}
  
  
  
  /**
   * Performs an update
   */
  void Update() {
      
    //Create a handle to player info
    PlayerInfo@ playerInfo;
      
    //Iterate through all team spawns
    for (int i = 0; i < core.players.length; i++) {
    
      //Save reference to player info
      playerInfo = core.players.spawns[i];
      
      //Spawn player
      DoSpawnPlayer(playerInfo);
      
    }
    
    //Finished
    
  }
  
  
  
  /**
   * Adds a player to the spawn queue
   */
  void AddPlayerToSpawn(CPlayer@ player) {
    
    //Retrieve a reference to the info object for the player
    PlayerInfo@ playerInfo = core.getInfoFromPlayer(player);
    
    //Check if player info object is missing
    if(playerInfo is null) {
    
      return;
    
    }
    
    //Add player object to the spawn queue
    mPlayerInfoSpawnQueue.push_back(playerInfo);
    
    //Finished
    
  }
  
  
  
  /**
   * Adds a player to the spawn queue
   */
	void RemovePlayerFromSpawn(CPlayer@ player) {
    
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
  
  }
  
  
  
  /**
   * Checks whether a player is in the spawn queue or not
   */
  bool isSpawning(CPlayer@ player) {
    
    //Retrieve a reference to the info object for the player
    PlayerInfo@ playerInfo = core.getInfoFromPlayer(player);
  
		return mPlayerInfoSpawnQueue.find(playerInfo) != -1;
    
    //Finished
    
	}
  
  
  
  /**
   * Spawns a player
   */
  void DoSpawnPlayer( PlayerInfo@ playerInfo ) {
  
    //Call super class' version of this method
    RespawnSystem::DoSpawnPlayer(playerInfo);
    
    //Check for warm-up mode
    if(core.rules.isWarmup()) {
    
      //Set flag to start the game
      core.rules.SetCurrentState(GAME);
    
    }
    
    //Finished
  
  }
  
  
  
  /**
   * Checks if a player can be spawned
   */
  bool canSpawnPlayer(PlayerInfo@ playerInfo) {
  
    //Check if player info is not valid
    if(playerInfo is null) {
    
      return false; 
      
    }
    
    //Calculate lapsed time since game started
    int lapsedTime = core.mCurrentTime - core.mStartTime;
    
    //Determine day cycle time
    int dayCycleTime = core.rules.daycycle_speed * 60 * getTicksASecond();
    
    //Calculate the time of day
    int timeOfDay = lapsedTime % dayCycleTime;
    
    //Check if night time
    if(timeOfDay >= dayCycleTime/2) {
    
      return false;
      
    }
    
    return true;
    
    //Finished
    
  }
  
  
  
  /**
   * Provides a spawn location
   */
  Vec2f getSpawnLocation(PlayerInfo@ playerInfo) {
  
    //Create a location vector
    Vec2f location();
    
    //Retrieve a reference to the map object
    CMap@ map = getMap();
    
    //Create an array of handles for survivor spawns
    CBlob@[] mSurvivorSpawns;
  
    //Check that we have a valid map object reference
    if(map !is null) {
    
      //Retrieve a reference to any survivor spawn blobs
      getBlobsByTag("survivor_spawn", @mSurvivorSpawns);
      
      //Check if at least one spawn exist
      if(mSurvivorSpawns.length > 0) {
    
        //Retrieve the location of a random survivor spawn
        location = mSurvivorSpawns[XORRandom(mSurvivorSpawns.length)].getPosition();
      
      }
      
      //Check if no spawns exists
      else if {
      
        //Calculate the x-coordinate for the middle of the map
        f32 xLocation = map.tilemapwidth * map.tilesize / 2;
      
        //Keep location
        location = Vec2f(xLocation, map.getLandYAtX(xLocation));
        
      }
      
    }
    
    return location;
    
    //Finished
    
  }
  
};
