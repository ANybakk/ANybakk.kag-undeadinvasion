/*
 * UndeadInvasion rules core
 * 
 * TODO: Spawn additional types of undead?
 * 
 * Author: ANybakk
 * Based on previous work by: Eanmig
 */

#include "UndeadInvasionVariables.as";

#include "RulesCore.as";



/**
 * UndeadInvasionRulesCore
 * Represents the game rules
 */
shared class UndeadInvasionRulesCore : RulesCore {


  
  //Keep track of when the game started
  int mStartTime;
  
  //Keep track of the most current update
  int mCurrentTime;
  
  //Keep track of undead limit
  int mUndeadCountLimit;
  
  //Keep track of the number of undead available for spawning
  int mUndeadAvailable;
  
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
  void Setup(CRules@ rules = null, RespawnSystem@ respawnSystem = null) {
  
    //Call super class' version of this method
    RulesCore::Setup(rules, respawnSystem);
    
    //Store a reference to the respawn system
    @mRespawnSystem = cast<UndeadInvasionRespawnSystem@>(respawnSystem);
    
    //Create background music
    //TODO: Consider adding background music
    //server_CreateBlob( "Entities/Meta/WARMusic.cfg" );
    
    //Register game start time
    mStartTime = getGameTime();
    
    //Retrieve maximum undead count
    mUndeadCountLimit = UndeadInvasionVariables::UNDEAD_SPAWN_MAX_COUNT;
    
    //Set game state
    rules.SetCurrentState(WARMUP);
    
    //Initialize the amount of undead available for spawning
    mUndeadAvailable = mUndeadCountLimit;
    
    //Finished
    
  }
  
  
  
  /**
   * Update method
   */
  void Update() {
    
    //Check if game is over
    if (rules.isGameOver()) {
    
      return;
      
    }
    
    //Register current time
    mCurrentTime = getGameTime();
    
    //Retrieve the current game state
    u8 currentGameState = rules.getCurrentState();
    
    //Calculate lapsed time since game started
    int lapsedTime = mCurrentTime - mStartTime;
    
    //Check if warm-up period is active
    if(rules.isWarmup()) {
    
      //Check if teams have enough players
      if(_allTeamsHaveEnoughPlayers()) {
      
        //Start the game
        rules.SetCurrentState(GAME);
      
        //Show a blank message
        rules.SetGlobalMessage("");
        
      }
      
      //Otherwise, teams not ready
      else {
      
        //Show a waiting for survivors message
        rules.SetGlobalMessage("Waiting for enough survivors");
        
      }
      
    }
    
    //Check if the game is currently active
    else if(currentGameState == GAME) {
      
      //Check if no survivors
      if( !_anyTeamHasSurvivors() ) {
      
        rules.SetCurrentState(GAME_OVER);
      
        //Show a game over message
        rules.SetGlobalMessage("You have failed to defend this area. It is only a matter of time before the kingdom is overrun by the undead.");
      
      }
      
      //Otherwise, there are still survivors
      else {
      
        //Calculate how many days have passed
        int dayNumber = lapsedTime / (rules.daycycle_speed * 60 * getTicksASecond());
        
        //Calculate how far into the current day it is
        f32 timeOfDay = lapsedTime % (rules.daycycle_speed * 60 * getTicksASecond());
        
        //Determine if it's night time
        bool isNightTime = timeOfDay >= 0.66 * rules.daycycle_speed * 60 * getTicksASecond() && timeOfDay <= 0.9 * rules.daycycle_speed * 60 * getTicksASecond();
        
        //Determine what factor to use depending on time of day
        u8 dayOfTimeFactor = (isNightTime) ? UndeadInvasionVariables::UNDEAD_SPAWN_NIGHTTIMEFACTOR : UndeadInvasionVariables::UNDEAD_SPAWN_DAYTIMEFACTOR;
        
        //Determine if night has passed
        bool nightHasPassed = timeOfDay > 0.9 * rules.daycycle_speed * 60 * getTicksASecond();
        
        //Check if night has passed
        if(nightHasPassed) {
        
          //Show a night time survival message
          rules.SetGlobalMessage("Day is dawning. You survived the night.");
        
        //Otherwise, check if not night time
        } else if(!isNightTime) {
        
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
        else if(isNightTime) {
          
            //Show blank message
            rules.SetGlobalMessage("");
            
        }
        
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
                
                _spawnUndead(spawnSite.getPosition());
                
              }
              
              //Every 3rd second, check whether the spawn site's health is 2/4 - 3/4
              else if(
                  lapsedTime % (dayOfTimeFactor * UndeadInvasionVariables::UNDEAD_SPAWN_INTERVAL_2 * getTicksASecond()) == 0 
                  && spawnSite.getHealth() >=(spawnSite.getInitialHealth() * 2/4)
                  && spawnSite.getHealth() < (spawnSite.getInitialHealth() * 3/4)) {
                
                _spawnUndead(spawnSite.getPosition());
                
              }
              
              //Every 2nd second, check whether the spawn site's health is 1/4 - 2/4
              else if(
                  lapsedTime % (dayOfTimeFactor * UndeadInvasionVariables::UNDEAD_SPAWN_INTERVAL_3 * getTicksASecond()) == 0 
                  && spawnSite.getHealth() >=(spawnSite.getInitialHealth() * 1/4)
                  && spawnSite.getHealth() < (spawnSite.getInitialHealth() * 2/4)) {
                
                _spawnUndead(spawnSite.getPosition());
                
              }
              
              //Every second, check whether the spawn site's health is below 2/4
              else if(spawnSite.getHealth() < (spawnSite.getInitialHealth() * 1/4)) {
              
                _spawnUndead(spawnSite.getPosition());
                
              }
            
            
            }
            
            //Finished this iteration
            
          }
        
        }
      
      }
      
    }
    
    //Call super class' version of this method
    RulesCore::Update();
    
    //Finished

  }
  
  
  
  /**
   * Checks if all teams have at least one player
   */
  bool _allTeamsHaveEnoughPlayers()	{
  
    //Return result from other version of this method
    return _allTeamsHaveNumberOfPlayers(UndeadInvasionVariables::SURVIVOR_COUNT_START_MINIMUM);
    
	}
  
  
  
  /**
   * Checks if all teams have at least a certain number of player(s).
   * 
   * @param   number    minimum number of players.
   */
  bool _allTeamsHaveNumberOfPlayers(u8 number)	{
  
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
   * Checks if any team has any survivors
   */
  bool _anyTeamHasSurvivors()	{
  
    //Iterate through all teams
		for (uint i = 0; i < teams.length; i++) {
    
      //Check if team has any player
			if (teams[i].players_count > 0) {
        
        //Finished, this team has at least one player
				return true;
        
			}
      
		}
    
    //Finished, no team were found to have any players
		return false;
    
	}
  
  
  
  /**
   * Spawns an undead creature in a given place
   */
  void _spawnUndead(Vec2f position, string typeName = "Zombie" ) {
  
    //Check if there are any undead available for spawning
    if(mUndeadAvailable > 0) {
    
      //Spawn undead
      server_CreateBlob( typeName, -1, position);
      
      //Reduce available undead for spawning
      mUndeadAvailable--;
      
    }
    
  }
  
  

}