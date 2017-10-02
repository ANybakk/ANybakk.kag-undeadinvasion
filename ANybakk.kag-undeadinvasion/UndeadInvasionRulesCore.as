/*
 * UndeadInvasion rules core
 * 
 * TODO: Spawn additional types of undead?
 * TODO: Detect when the map cycle has reached an end and show a different fail message ("The kingdom has fallen!")
 * 
 * TODO: Set mode to warm-up when last player leaves (Spawn system's job?)
 * 
 * Author: ANybakk
 * Based on previous work by: Eanmig
 */

#include "UndeadInvasionVariables.as"
#include "EntitySpawn.as"
#include "Rules.as"
#include "RulesCore.as"
#include "UndeadInvasionRespawnSystem.as"

#include "MakeCrate.as" //For shipments



/**
 * UndeadInvasionRulesCore
 * Represents the game rules
 */
class UndeadInvasionRulesCore : RulesCore {



  //Keep track of when the game started
  int mStartTime;
  
  //Keep track of the most current update
  int mCurrentTime;
  
  //Keep track of undead limit
  int mUndeadCountLimit;
  
  //Keep track of the number of undead available for spawning
  int mUndeadAvailable;
  
  //Keep track of whether shipments were sent
  bool mShipmentsSent;
  
  //Keep a handle for the respawn system
  UndeadInvasionRespawnSystem@ mRespawnSystem;
  
  
  
  /**
   * Default constructor
   */
  UndeadInvasionRulesCore() {
    
    super();
    
    //Finished
    
  }
  
  
  
  /**
   * Constructor
   */
  UndeadInvasionRulesCore(CRules@ rules, RespawnSystem@ respawnSystem) {
    
    super(rules, respawnSystem);
    
    //Finished
    
  }
  
  
  
  /**
   * Setup method
   */
  void Setup(CRules@ rules = null, RespawnSystem@ respawnSystem = null) override {
  
    //Call super class' version of this method
    RulesCore::Setup(rules, respawnSystem);
    
    //Store a reference to the respawn system
    @mRespawnSystem = cast<UndeadInvasionRespawnSystem@>(respawnSystem);
    
    //Register game start time
    mStartTime = getGameTime();
    
    //Retrieve maximum undead count
    mUndeadCountLimit = UndeadInvasionVariables::UNDEAD_SPAWN_MAX_COUNT;
    
    //Set game state
    rules.SetCurrentState(WARMUP);
    
    //Initialize the amount of undead available for spawning
    mUndeadAvailable = mUndeadCountLimit;
    
    //Create audio meta entity
    server_CreateBlob("Undead Invasion Audio");
    
    //Finished
    
  }
  
  
  
  /**
   * Update method
   */
  void Update() override {
    
    //Check if game is over
    if (rules.isGameOver()) {
    
      return;
      
    }
    
    //Register current time
    mCurrentTime = getGameTime();
    
    //Retrieve the current game state
    u8 currentGameState = rules.getCurrentState();
    
    //Check if warm-up period is active
    if(rules.isWarmup()) {
    
      //Check if teams have enough players
      if(allTeamsHaveEnoughPlayers()) {
      
        //Start the game
        rules.SetCurrentState(GAME);
      
        //Show a blank message
        rules.SetGlobalMessage("");
        
      }
      
      //Otherwise, teams not ready
      else {
      
        //Show a waiting for survivors message
        rules.SetGlobalMessage("Waiting for enough players");
        
      }
      
    }
    
    //Check if the game is currently active
    else if(currentGameState == GAME) {
      
      //Check if no survivors
      //TODO: Or no survivor spawns are left
      if(!anySurvivorTeamHasPlayersAlive()) {
      
        //Set game over state
        rules.SetCurrentState(GAME_OVER);
      
        //Show a game over message
        rules.SetGlobalMessage("The survivors have failed to defend this area. Other areas await!");
      
      }
      
      //Otherwise, there are still survivors
      else {
        
        //Check if night has passed
        if(ANybakk::Rules::nightHasPassed(rules)) {
        
          //Show a night time survival message
          rules.SetGlobalMessage("Day is dawning. The survivors have made it through the night.");
          
          //If shipments haven't been sent already
          if(!mShipmentsSent) {
          
            //Time to spawn shipments
            spawnShipments();
            
            //Remember
            mShipmentsSent = true;
            
          }
        
        //Otherwise, check if not night time
        } else if(!ANybakk::Rules::isNightTime(rules)) {
      
          //Determine how many days have passed
          int dayNumber = ANybakk::Rules::getDayNumber(rules);
        
          //Check if not first day
          if(dayNumber > 0) {
          
            //Show day passage message
            rules.SetGlobalMessage("Days since Z-Day: " + dayNumber);
            
          }
          
          //Otherwise, first day
          else {
          
            //Show invasion alert message
            rules.SetGlobalMessage("The dead are walking! Prepare yourselves! Defend the kingdom!");
            
          }
          
        }
        
        //Otherwise, check if night time
        else if(ANybakk::Rules::isNightTime(rules)) {
          
            //Show blank message
            rules.SetGlobalMessage("");
            
            //Reset shipment flag
            mShipmentsSent = false;
            
        }
        
        updateUndeadSpawnSites();
        
      }
      
    }
    
    //Call super class' version of this method
    RulesCore::Update();
    
    //Finished

  }
  
  
  
  /**
   * Update handler for undead spawn sites. Spawns undead under the right circumstances.
   */
  void updateUndeadSpawnSites() {
  
    //Determine lapsed time since game started
    int lapsedTime = ANybakk::Rules::getLapsedTime(rules);
    
    //Determine what factor to use depending on time of day
    u8 dayOfTimeFactor = (ANybakk::Rules::isNightTime(rules)) ? UndeadInvasionVariables::UNDEAD_SPAWN_NIGHTTIMEFACTOR : UndeadInvasionVariables::UNDEAD_SPAWN_DAYTIMEFACTOR;
    
    //Every second
    if(lapsedTime % (dayOfTimeFactor * UndeadInvasionVariables::UNDEAD_SPAWN_INTERVAL_4 * getTicksASecond()) == 0) {
    
      //Create an array of blob references
      CBlob@[] undeadBlobs;
      
      //Retrieve references to any undead blobs
      getBlobsByTag("isUndead", @undeadBlobs);
      
      //Update undead spawn available count
      mUndeadAvailable = mUndeadCountLimit - undeadBlobs.length;
      
      //Create an array of blob references
      CBlob@[] undeadSpawnSites;
      
      //Retrieve references to all undead spawn sites
      getBlobsByTag("isUndeadSpawn", @undeadSpawnSites);
      
      //Create a spawn site blob handle
      CBlob@ spawnSite;
      
      //Iterate over all undead spawn sites
      //TODO: Randomize sequence?
      for(int i=0; i<undeadSpawnSites.length; i++) {
        
        //Check whether there are any undead available for spawning
        if(mUndeadAvailable <= 0) {
        
          break;
          
        } else {
    
          //Keep a reference to the spawn site blob object
          @spawnSite = undeadSpawnSites[i];
          
          //Every 4th second, check whether the spawn site's health is 3/4 - 4/4
          if(
              lapsedTime % (dayOfTimeFactor * UndeadInvasionVariables::UNDEAD_SPAWN_INTERVAL_1 * getTicksASecond()) == 0 
              && spawnSite.getHealth() >=(spawnSite.getInitialHealth() * 3/4)) {
            
            spawnUndead(spawnSite.getPosition());
            
          }
          
          //Every 3rd second, check whether the spawn site's health is 2/4 - 3/4
          else if(
              lapsedTime % (dayOfTimeFactor * UndeadInvasionVariables::UNDEAD_SPAWN_INTERVAL_2 * getTicksASecond()) == 0 
              && spawnSite.getHealth() >=(spawnSite.getInitialHealth() * 2/4)
              && spawnSite.getHealth() < (spawnSite.getInitialHealth() * 3/4)) {
            
            spawnUndead(spawnSite.getPosition());
            
          }
          
          //Every 2nd second, check whether the spawn site's health is 1/4 - 2/4
          else if(
              lapsedTime % (dayOfTimeFactor * UndeadInvasionVariables::UNDEAD_SPAWN_INTERVAL_3 * getTicksASecond()) == 0 
              && spawnSite.getHealth() >=(spawnSite.getInitialHealth() * 1/4)
              && spawnSite.getHealth() < (spawnSite.getInitialHealth() * 2/4)) {
            
            spawnUndead(spawnSite.getPosition());
            
          }
          
          //Every second, check whether the spawn site's health is below 2/4
          else if(spawnSite.getHealth() < (spawnSite.getInitialHealth() * 1/4)) {
          
            spawnUndead(spawnSite.getPosition());
            
          }
        
        
        }
        
        //Finished this iteration
        
      }
    
    }
        
  }
  
  
  
  /**
   * Checks if all teams have at least one player
   */
  bool allTeamsHaveEnoughPlayers()	{
  
    //Retrieve minimum player count variable
    s8 playerCountMinimum = UndeadInvasionVariables::PLAYER_COUNT_START_MINIMUM;
    
    //Check if player count minimum is not disabled (negative number)
    if(playerCountMinimum >= 0) {
    
      //Finished, return result from other version of this method
      return allTeamsHaveNumberOfPlayers(UndeadInvasionVariables::PLAYER_COUNT_START_MINIMUM);
      
    }
    
    //Otherwise, player count minimum disabled
    else {
    
      //Finished, return result from survivor team check
      return survivorTeamsHasEnoughPlayers();
    
    }
    
	}
  
  
  
  /**
   * Checks if all teams have at least a certain number of player(s).
   * 
   * @param   number    minimum number of players.
   */
  bool allTeamsHaveNumberOfPlayers(u8 number)	{
  
    //Iterate through all teams
		for (uint i = 0; i < teams.length; i++) {
    
      //Check if team has less than one player
			if (teams[i].players_count < number) {
        
        //Finished, this team does not have enough players
				return false;
        
			}
      
		}
    
    //Finished, no teams were found to not have enough players
		return true;
    
	}
  
  
  
  /**
   * Checks if there's a survivor team and that the minimum number of survivors are present.
   */
  bool survivorTeamsHasEnoughPlayers() {
    
    //Finished, return result from other version of this method
    return survivorTeamsHasEnoughPlayers(UndeadInvasionVariables::SURVIVOR_COUNT_START_MINIMUM);
  
  }
  
  
  
  /**
   * Checks if there's a survivor team and number of members exceeds the criteria
   * 
   * @param   number    number criteria.
   */
  bool survivorTeamsHasEnoughPlayers(u8 number) {
  
    //Iterate through all teams
		for(uint i = 0; i < teams.length; i++) {
    
      //Check if not undead team and player count is enough
      if(teams[i].name != "Undead team" && teams[i].players_count >= number) {
        
        //Finished, enough players in survivor team
        return true;
        
      }
    
    }
    
    //Finished, survivor team not present or empty
    return false;
  
  }
  
  
  
  /**
   * Checks if any team has any survivors
   */
  bool anyTeamHasPlayers()	{
  
    //Iterate through all teams
		for(uint i=0; i<teams.length; i++) {
    
      //Check if team has any players
			if(teams[i].players_count > 0) {
        
        //Finished, this team has at least one player
				return true;
        
			}
      
		}
    
    //Finished, no team were found to have any players
		return false;
    
	}
  
  
  
  /**
   * Checks if any team has any survivors
   */
  bool anySurvivorTeamHasPlayersAlive()	{
  
    //Iterate through all teams
		for(uint i=0; i<teams.length; i++) {
      
      //Check if not undead team
      if(teams[i].name != "Undead team") {
      
        //Iterate through all players
        for(uint j=0; j<players.length; j++) {
        
          //Check if player is on this team and isn't tagged as dead
          if(players[j].team == teams[i].index) {
          
            //Obtain a reference to this player's blob
            CBlob@ survivorBlob = getPlayerByUsername(players[j].username).getBlob();
            
            //Check if blob is valid and not tagged as dead
            if(survivorBlob !is null && !survivorBlob.hasTag("dead")) {
            
              //Finished, this team has at least one player
              return true;
              
            }
            
          }
          
        }
        
      }
      
		}
    
    //Finished, no team were found to have any players
		return false;
    
	}
  
  
  
  /**
   * Spawns an undead CreatureBlob in a given place
   */
  void spawnUndead(Vec2f position) {
  
    //Check if there are any undead available for spawning
    if(mUndeadAvailable > 0) {
    
      //Get a random value between 0 and 100
      u8 randomChance = XORRandom(100);
      
      //Get a reference to the spawn mix array
      UndeadInvasion::EntitySpawn[] spawnMix = UndeadInvasionVariables::UNDEAD_ENTITY_SPAWN_MIX;
      
      //Create an entity spawn object handle
      UndeadInvasion::EntitySpawn spawn;
      
      //Keep track of accumulated spawn chance
      u8 accumulatedChance = 0;
      
      //Iterate through all entity spawn objects (think: percentage pie chart)
      for(u8 i=0; i<spawnMix.length; i++) {
      
        //Keep a reference to this entity spawn object
        spawn = UndeadInvasionVariables::UNDEAD_ENTITY_SPAWN_MIX[i];
        
        //Check if random chance value is within this window
        if(randomChance > accumulatedChance && randomChance < accumulatedChance + spawn.mSpawnChance) {
        
          //Spawn this entity
          server_CreateBlob( spawn.mEntityName, -1, position);
          
          //Reduce available undead for spawning
          mUndeadAvailable--;
          
          //Exit loop
          break;
        
        }
        
        //Accumulate chance value
        accumulatedChance += spawn.mSpawnChance;
        
      }
      
    }
    
  }
  
  
  
  /**
   * Spawns shipments at any survivor spawn sites
   */
  void spawnShipments() {

    //Create an array of blob references
    CBlob@[] survivorSpawnSites;

    //Retrieve references to all survivor spawn sites
    getBlobsByTag("isSurvivorSpawn", @survivorSpawnSites);

    //Create a spawn site blob handle
    CBlob@ spawnSite;

    //Iterate over all survivor spawn sites
    for(int i=0; i<survivorSpawnSites.length; i++) {

      //Keep a reference to the spawn site blob object
      @spawnSite = survivorSpawnSites[i];
      
      //Create crate (MakeCrate.as)
      CBlob@ crate = server_MakeCrateOnParachute("", "", 5, spawnSite.getTeamNum(), getDropPosition(spawnSite.getPosition()));
      
      //Continue, if valid reference
      if (crate !is null) {
      
        //Enable unpack button
        crate.Tag("unpackall");
        
        //Create a material blob handle
        CBlob@ material;
        
        {
        
          //Create wood material
          @material = server_CreateBlob("mat_wood");
          
          //Put into crate inventory, if reference is valid
          if(material !is null) {
              crate.server_PutInInventory(material);
          }
          
        }
        
      }
      
    }
    
  }
  
  
  
}