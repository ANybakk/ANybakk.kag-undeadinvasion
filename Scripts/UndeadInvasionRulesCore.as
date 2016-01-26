/*
 * UndeadInvasion rules core
 * 
 * TODO: Tag all kinds of "zombies" as "undead"
 * TODO: Spawn additional types of undead?
 * 
 * Author: ANybakk
 * Based on previous work by: Eanmig
 */
 
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
    //TODO: Variable from CRules returned as 0
    mUndeadCountLimit = 125; //rules.get_u8("undead_count_limit");
    
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
    
      //Do nothing
      
    }
    
    //Check if the game is currently active
    else if(currentGameState == GAME) {
    
      //Every second
      if(lapsedTime % getTicksASecond() == 0) {
      
        //Create an array of blob references
        CBlob@[] undeadBlobs;
        
        //Retrieve references to any undead blobs
        //TODO: Generalize for any kind of undead
        getBlobsByName("Zombie", @undeadBlobs);
        
        //Update undead spawn available count
        mUndeadAvailable = mUndeadCountLimit - undeadBlobs.length;
        
        //Create an array of blob references
        CBlob@[] undeadSpawnSites;
        
        //Retrieve references to all undead spawn sites
        //TODO: Generalize so that multiple types of spawn sites can be included (use tag)
        getBlobsByName("Mausoleum", @undeadSpawnSites);
        
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
                lapsedTime % (getTicksASecond() * 4) == 0 
                && spawnSite.getHealth() >=(spawnSite.getInitialHealth() * 3/4)) {
              
              _spawnUndead(spawnSite.getPosition());
              
            }
            
            //Every 3rd second, check whether the spawn site's health is 2/4 - 3/4
            else if(
                lapsedTime % (getTicksASecond() * 3) == 0 
                && spawnSite.getHealth() >=(spawnSite.getInitialHealth() * 2/4)
                && spawnSite.getHealth() < (spawnSite.getInitialHealth() * 3/4)) {
              
              _spawnUndead(spawnSite.getPosition());
              
            }
            
            //Every 2nd second, check whether the spawn site's health is 1/4 - 2/4
            else if(
                lapsedTime % (getTicksASecond() * 2) == 0 
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
    
    //Call super class' version of this method
    RulesCore::Update();
    
    //Finished

  }
  
  
  
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