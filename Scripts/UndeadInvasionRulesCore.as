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
  
  //Keeep track of undead portals
  CBlob@[] mPortals;
  
  //Keep track of portal max health
  int mPortalMaxHealth;
  
  //Keeep track of undead
  CBlob@[] mUndead;
  
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
    //server_CreateBlob( "Entities/Meta/WARMusic.cfg" );
    
    //Register game start time
    mStartTime = getGameTime();
    
    //Retrieve maximum undead count
    mUndeadCountLimit = rules.get_s32("undead_count_limit");
    
    //Set game state
    rules.SetCurrentState(WARMUP);
    
    //Finished
    return;
    
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
    
    //Retrieve references to all portals
    getBlobsByTag("portal", @mPortals);
    
    //Retrieve references to all undead
    getBlobsByTag("zombie", @mUndead);
    
    //Retrieve the current game state
    u8 currentGameState = rules.getCurrentState();
    
    //Calculate lapsed time since game started
    int lapsedTime = mCurrentTime - mStartTime;    
    
    //Check if warm-up period is active
    if(rules.isWarmup()) {
        
      //Initialize the amount of undead available for spawning
      mUndeadAvailable = mUndeadCountLimit;
      
      //Check if any portals exists
      if(mPortals.length > 0) {
      
        //Store maximum portal health to be like the first portal
        mPortalMaxHealth = mPortals[0].getHealth();
      
      }
      
      //Store a default maximum portal health
      //TODO: Turn this into a variable
      mPortalMaxHealth = 50;
      
    }
    
    //Check if the game is currently active
    else if(currentGameState == GAME) {
    
      //Every second
      if(lapsedTime % getTicksASecond() == 0) {
    
        //Create a portal blob handle
        CBlob@ portal;
      
        //Iterate over all portals
        for(int i=0; i<mPortals.length; i++) {
          
          //Check whether there are any undead available for spawning
          if(mUndeadAvailable <= 0) {
          
            break;
            
          } else {
      
            //Keep a reference to the portal blob object
            @portal = mPortals[i];
            
            //Every 4th second, check whether the portal's health is 3/4 - 4/4
            if(
                lapsedTime % (getTicksASecond() * 4) == 0 
                && portal.getHealth() >=(mPortalMaxHealth * 3/4)) {
              
              //Spawn undead
              server_CreateBlob( "Zombie", -1, portal.getPosition());
      
              //Retrieve references to all undead
              getBlobsByTag("Zombie", @mUndead );
              
              //Reduce available undead for spawning
              mUndeadAvailable--;
              
            }
            
            //Every 3rd second, check whether the portal's health is 2/4 - 3/4
            else if(
                lapsedTime % (getTicksASecond() * 3) == 0 
                && portal.getHealth() >=(mPortalMaxHealth * 2/4)
                && portal.getHealth() < (mPortalMaxHealth * 3/4)) {
              
              //Spawn undead
              server_CreateBlob( "Zombie", -1, portal.getPosition());
      
              //Retrieve references to all undead
              getBlobsByTag("Zombie", @mUndead );
              
              //Reduce available undead for spawning
              mUndeadAvailable--;
              
            }
            
            //Every 2nd second, check whether the portal's health is 1/4 - 2/4
            else if(
                lapsedTime % (getTicksASecond() * 2) == 0 
                && portal.getHealth() >=(mPortalMaxHealth * 1/4)
                && portal.getHealth() < (mPortalMaxHealth * 2/4)) {
              
              //Spawn undead
              server_CreateBlob( "Zombie", -1, portal.getPosition());
      
              //Retrieve references to all undead
              getBlobsByTag("Zombie", @mUndead );
              
              //Reduce available undead for spawning
              mUndeadAvailable--;
              
            }
            
            //Every second, check whether the portal's health is below 2/4
            else if(portal.getHealth() < (mPortalMaxHealth * 1/4)) {
            
              //Spawn undead
              server_CreateBlob( "Zombie", -1, portal.getPosition());
      
              //Retrieve references to all undead
              getBlobsByTag("Zombie", @mUndead );
              
              //Reduce available undead for spawning
              mUndeadAvailable--;
              
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

}