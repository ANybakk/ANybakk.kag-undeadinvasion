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
class UndeadInvasionRespawnSystem : RespawnSystem {


  
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
    
    //Check if player info object is missing or spectator team
    if(playerInfo is null || player.getTeamNum() == core.rules.getSpectatorTeamNum()) {
    
      return;
    
    }
    
    //Make sure player is not in queue
    RemovePlayerFromSpawn(player);
    
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
    
    //Create vector result variable
    Vec2f result;
    
    //Retrieve a reference to the map object
    CMap@ map = getMap();
    
    //Check that we have a valid map object reference
    if(map !is null) {
    
      //Retrieve team number
      u8 teamNumber = playerInfo.team;
      
      bool isUndeadTeam = core.teams[teamNumber].name == "Undead team";
      
      //Create an array of potential spawn site blob references
      CBlob@[] potentialSpawnSites;
      
      //Create a potential spawn site blob handle
      CBlob@ potentialSpawnSite;
      
      //Create an array of available spawn site blob references
      CBlob@[] availableSpawnSites;
      
      //Create an array of free spawn site blob references
      CBlob@[] freeSpawnSites;
      
      //Determine type of spawn site to look for
      string spawnSiteTag = (isUndeadTeam) ? "isUndeadSpawn" : "isSurvivorSpawn";
      
      //Retrieve references to all potential spawn sites
      getBlobsByTag(spawnSiteTag, @potentialSpawnSites);
      
      //Check if at least one spawn exist
      if(potentialSpawnSites.length > 0) {
        
        //Iterate through all potential spawn sites
        for(uint i=0; i<potentialSpawnSites.length; i++) {
        
          //Keep a reference to this spawn site
          @potentialSpawnSite = potentialSpawnSites[i];
          
          //Check if this spawn site is owned by the right team
          if(potentialSpawnSite.getTeamNum() == teamNumber) {
          
            //Append to available array
            availableSpawnSites.push_back(potentialSpawnSite);
            
          }
          
          //Otherwise, check if not owned by any team
          else if(potentialSpawnSite.getTeamNum() > 10) {
          
            //Append to free array
            freeSpawnSites.push_back(potentialSpawnSite);
          
          }
        
        }
        
        //Check if any available sites were found
        if(availableSpawnSites.length > 0) {
        
          //Pick a random spawn site among the available
          result = availableSpawnSites[XORRandom(availableSpawnSites.length)].getPosition();
          
        }
        
        //Otherwise, check if any free sites were found
        else if(freeSpawnSites.length > 0) {
        
          //Pick a random spawn site among the free
          result = freeSpawnSites[XORRandom(freeSpawnSites.length)].getPosition();
          
        }
        
      
      }
      
      /* TODO: Only if map file didn't have spawn sites defined
      //Otherwise, check if undead team
      else if(isUndeadTeam){
      
        //Calculate the x-coordinate for a random edge of the map (6 tiles offset)
        f32 xLocation = (XORRandom(2) == 0) ? 0.0f + 6 * map.tilesize : 0.0f + map.tilemapwidth - 6 * map.tilesize;
        
        //Get the y-coordinate
        f32 yLocation = map.getLandYAtX(s32(xLocation/map.tilesize)) * map.tilesize - 16.0f;
        
        //Return location
        result = Vec2f(xLocation, yLocation);
        
      }
      
      //Otherwise, check if not undead team
      else if(!isUndeadTeam) {
        
          //Calculate the x-coordinate for the middle of the map
          f32 xLocation = map.tilemapwidth * map.tilesize / 2;
          
          //Get the y-coordinate
          f32 yLocation = map.getLandYAtX(s32(xLocation/map.tilesize)) * map.tilesize - 16.0f;
          
          //Return location
          result = Vec2f(xLocation, yLocation);
          
      }
      */
      
    }
    
    //Otherwise (map reference is missing)
    else {
    
      //Set result as zero vector
      result = Vec2f(0,0);
      
    }
    
    //Finished, return result
    return result;
    
  }
  
  
  
  //Class declaration finished
  
}