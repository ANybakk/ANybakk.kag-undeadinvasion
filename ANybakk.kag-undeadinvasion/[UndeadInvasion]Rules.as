/*
 * UndeadInvasion rules script
 * 
 * This script is primarily responsible for initializing the respawn system and 
 * RulesCore.
 * 
 * Author: ANybakk
 */

#define SERVER_ONLY

#include "MakeCrate.as"; //For shipments

#include "[Base]Rules.as";

#include "[UndeadInvasion].as";
#include "[UndeadInvasion]EntitySpawn.as";
#include "[UndeadInvasion]RulesVariables.as";



namespace UndeadInvasion {

  namespace Rules {
  
  
  
    /**
     * Initialization
     */
    void onInit(CRules@ this) {
    
      print("[UndeadInvasion::Rules::onInit]");
      
      Base::Rules::onInit(this);
      
      //Call restart event function
      onRestart(this);
      
      //Finished
      return;
      
    }
    
    
    
    /**
     * Restart
     */
    void onRestart(CRules@ this) {
    
      print("[UndeadInvasion::Rules::onRestart]");
      
      //Set no timer flag (used by TimeToEnd.as)
      this.set_bool("no timer", true);
      
      u16[] playerIDQueue;
      this.set("UndeadInvasion::Rules::playerIDQueue", playerIDQueue);
      
      u8[] playerTeamQueue;
      this.set("UndeadInvasion::Rules::playerTeamQueue", playerTeamQueue);
      
      this.set_u16("UndeadInvasion::Rules::startTime", getGameTime()
      );
      
      this.set_u8(
          "UndeadInvasion::Rules::undeadCountAvailable"
        , UndeadInvasion::RulesVariables::UNDEAD_SPAWN_MAX_COUNT
      );
      
      this.set_bool("UndeadInvasion::Rules::shipmentSent", false);
      
      //Set game state
      this.SetCurrentState(WARMUP);
      
      //Create audio meta entity
      server_CreateBlob("Undead Invasion Audio");
      
    }
    
    
    
    /**
     * State change
     */
    void onStateChange(CRules@ this, const u8 oldState) {
    
      print("[UndeadInvasion::Rules::onStateChange] (oldState=" + oldState + ")");
      
      //If game just ended
      if(this.getCurrentState() == GAME_OVER) {
      
        this.set_u16("UndeadInvasion::Rules::nextMapCooldown", UndeadInvasion::RulesVariables::NEXT_MAP_COOLDOWN * getTicksASecond());
        
      }
      
    }
    
    
    
    /**
     * Tick
     */
    void onTick(CRules@ this) {
    
      //If game over
      if(this.getCurrentState() == GAME_OVER) {
      
        advanceTowardMapChange(this);
        
        return;
        
      }
      
      //If warm-up
      if(this.getCurrentState() == WARMUP) {
      
        //Check if teams have enough players
        if(allTeamsHaveEnoughPlayers(this)) {
          
          //Start the game
          this.SetCurrentState(GAME);
        
          //Show a blank message
          this.SetGlobalMessage("");
        
          //Iterate through any players
          for(int i=0; i<::getPlayersCount(); i++) {
          
            //Add to queue
            addPlayerToQueue(this, getPlayer(i));
            
          }
          
        }
        
        //Otherwise, teams not ready
        else {
        
          //Show a waiting for survivors message
          this.SetGlobalMessage("Waiting for enough players");
          
        }
        
      }
      
      //Otherwise, if game running
      else if(this.getCurrentState() == GAME) {
        
        //Check if no survivors
        //TODO: Or no survivor spawns are left
        if(!anySurvivorTeamHasPlayersAlive(this)) {
        
          //Set game over state
          this.SetCurrentState(GAME_OVER);
        
          //Show a game over message
          this.SetGlobalMessage(
            "The survivors have failed to defend this area. Other areas await!"
          );
          
          //this.SetTeamWon(0);
          //sv_mapautocycle = true;
        
        }
        
        //Otherwise, there are still survivors
        else {
          
          //If night has passed
          if(Base::Rules::nightHasPassed(this)) {
          
            //Show a night time survival message
            this.SetGlobalMessage("Day is dawning. The survivors have made it through the night.");
            
            //If shipments haven't been sent already
            if(!this.get_bool("UndeadInvasion::Rules::shipmentSent")) {
            
              //Time to spawn shipments
              spawnShipments();
              
              //Remember
              this.set_bool("UndeadInvasion::Rules::shipmentSent", true);
              
            }
          
          }
          
          //Otherwise, if not night time
          else if(!Base::Rules::isNightTime(this)) {
        
            //Determine how many days have passed
            int dayNumber = Base::Rules::getDayNumber(this);
          
            //Check if not first day
            if(dayNumber > 0) {
            
              //Show day passage message
              this.SetGlobalMessage("Days since Z-Day: " + dayNumber);
              
            }
            
            //Otherwise, first day
            else {
            
              //Show invasion alert message
              this.SetGlobalMessage("The dead are walking! Prepare yourselves! Defend the kingdom!");
              
            }
            
          }
          
          //Otherwise, if night time
          else if(Base::Rules::isNightTime(this)) {
            
              //Show blank message
              this.SetGlobalMessage("");
              
              //Reset shipment flag
              this.set_bool("UndeadInvasion::Rules::shipmentSent", false);
              
          }
          
          updateUndeadSpawnSites(this);
          
        }
        
      }
      
      //If daytime
      if(Base::Rules::isDayTime(this)) {
        
        spawnPlayerFromQueue(this);
        
      }
      
    }
    
    
    
    /**
     * Player spawn
     */
    void onPlayerRequestSpawn(CRules@ this, CPlayer@ player) {
    
      CTeam@ team;
      u8[] survivorTeams;
      
      //Iterate through teams
      for(u8 i=0; i<this.getTeamsCount(); i++) {
      
        @team = this.getTeam(i);
        
        //If survivor team
        if(team.getName().find("Survivor") != -1) {
        
          survivorTeams.push_back(i);
          
        }
        
      }
      
      //Assign to random team
      player.server_setTeamNum(survivorTeams[XORRandom(survivorTeams.length)]);
      
      //Add to queue
      addPlayerToQueue(this, player);
      
    }
    
    
    
    /**
     * Attempts to add a player to the queue. If the player is already bound to 
     * a blob, the player is not added. If the player is already in the queue, 
     * it is moved to the last position in the queue.
     */
    void addPlayerToQueue(CRules@ this, CPlayer@ player) {
      
      if(player is null) {
        return;
      }
      
      //Get reference to any existing blob for this player
      CBlob @playerBlob = player.getBlob();
      
      //If valid reference, abort (no need to queue up)
      if(playerBlob !is null) {
        return;
      }
      
      //Get queue
      u16[]@ playerIDQueue;
      this.get("UndeadInvasion::Rules::playerIDQueue", @playerIDQueue);
      u8[]@ playerTeamQueue;
      this.get("UndeadInvasion::Rules::playerTeamQueue", @playerTeamQueue);
      
      //Locate the player in the spawn queue
      int positionInQueue = playerIDQueue.find(player.getNetworkID());
      
      //Check if the player was in the queue
      if(positionInQueue != -1) {
      
        //Remove the player from the queue
        playerIDQueue.erase(positionInQueue);
        playerTeamQueue.erase(positionInQueue);
        
      }
        
      //Add to queue
      playerIDQueue.push_back(player.getNetworkID());
      playerTeamQueue.push_back(player.getTeamNum());
      
    }
    
    
    
    /**
     * Attempts to spawn the first player from the queue. The players is then 
     * removed from the queue. If the queued player is invalid, no spawning is 
     * performed.
     */
    CPlayer@ spawnPlayerFromQueue(CRules@ this) {
      
      //Get queue
      u16[]@ playerIDQueue;
      this.get("UndeadInvasion::Rules::playerIDQueue", @playerIDQueue);
      u8[]@ playerTeamQueue;
      this.get("UndeadInvasion::Rules::playerTeamQueue", @playerTeamQueue);
      
      //If any players in queue
      if(playerIDQueue.length > 0) {
        
        //Obtain first player reference
        CPlayer @player = getPlayerByNetworkId(playerIDQueue[0]);
        
        //If player is valid
        if(player !is null) {
          
          //Create blob
          CBlob@ playerBlob = server_CreateBlob(
              UndeadInvasion::RulesVariables::SURVIVOR_SPAWN_BLOB_NAME    //
            , playerTeamQueue[0]                                          //team
            , getSpawnLocation(this, playerTeamQueue[0])                  //Position
          );
          
          //Bind to player
          playerBlob.server_SetPlayer(player);
          
        }
      
        //Remove from queue
        playerIDQueue.erase(0);
        playerTeamQueue.erase(0);
        
        return player;
        
      }
      
      return null;
      
    }
    
    
    
    /**
     * Advances to map change by one step according to cooldown. When the 
     * counter reaches zero, the next map is loaded.
     */
    void advanceTowardMapChange(CRules@ this) {
      
      u16 cooldown = this.get_u16("UndeadInvasion::Rules::nextMapCooldown");
      
      if(cooldown == 0) {
        LoadNextMap();
      }
      
      else {
        this.set_u16("UndeadInvasion::Rules::nextMapCooldown", cooldown-1);
      }
      
    }
    
    
    
    /**
     * Provides a spawn location
     * TODO: Handle different teams
     */
    Vec2f getSpawnLocation(CRules@ this, u8 teamNumber) {
      
      //Obtain map reference
      CMap@ map = getMap();
      
      if(map is null) {
        return Vec2f(0,0);
      }
      
      else {
        
        //Obtain team information
        CTeam @team = this.getTeam(teamNumber);
        
        //Determine if undead team
        bool isUndeadTeam = team.getName() == "Undead team";
        
        //Determine type of spawn site to look for
        string spawnSiteTag = (isUndeadTeam) ? "isUndeadSpawn" : "isSurvivorSpawn";
        
        //Obtain references to all potential spawn sites
        CBlob@[] potentialSpawnSites;
        getBlobsByTag(spawnSiteTag, @potentialSpawnSites);
        
        CBlob@ potentialSpawnSite;
        CBlob@[] availableSpawnSites;
        CBlob@[] freeSpawnSites;
        
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
            return availableSpawnSites[XORRandom(availableSpawnSites.length)].getPosition();
            
          }
          
          //Otherwise, check if any free sites were found
          else if(freeSpawnSites.length > 0) {
          
            //Pick a random spawn site among the free
            return freeSpawnSites[XORRandom(freeSpawnSites.length)].getPosition();
            
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
          return Vec2f(xLocation, yLocation);
          
        }
        
        //Otherwise, check if not undead team
        else if(!isUndeadTeam) {
          
            //Calculate the x-coordinate for the middle of the map
            f32 xLocation = map.tilemapwidth * map.tilesize / 2;
            
            //Get the y-coordinate
            f32 yLocation = map.getLandYAtX(s32(xLocation/map.tilesize)) * map.tilesize - 16.0f;
            
            //Return location
            return Vec2f(xLocation, yLocation);
            
        }
        */
        
      }
      
      return Vec2f(0,0);
      
    }
    
    
    
    /**
     * Update handler for undead spawn sites. Spawns undead under the right 
     * circumstances.
     */
    void updateUndeadSpawnSites(CRules@ this) {
    
      //Determine lapsed time since game started
      int lapsedTime = Base::Rules::getLapsedTime(this);
      
      //Determine what factor to use depending on time of day
      u8 dayOfTimeFactor = 
        (Base::Rules::isNightTime(this)) ? 
          UndeadInvasion::RulesVariables::UNDEAD_SPAWN_NIGHTTIMEFACTOR
        : UndeadInvasion::RulesVariables::UNDEAD_SPAWN_DAYTIMEFACTOR
      ;
      
      //Every second
      if(lapsedTime % (dayOfTimeFactor * UndeadInvasion::RulesVariables::UNDEAD_SPAWN_INTERVAL_4 * getTicksASecond()) == 0) {
      
        //Create an array of blob references
        CBlob@[] undeadBlobs;
        
        //Retrieve references to any undead blobs
        getBlobsByTag("isUndead", @undeadBlobs);
        
        //Update undead spawn available count
        this.set_u8(
            "UndeadInvasion::Rules::undeadCountAvailable"
          , UndeadInvasion::RulesVariables::UNDEAD_SPAWN_MAX_COUNT - undeadBlobs.length
        );
        
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
          if(this.get_u8("UndeadInvasion::Rules::undeadCountAvailable") <= 0) {
          
            break;
            
          } else {
      
            //Keep a reference to the spawn site blob object
            @spawnSite = undeadSpawnSites[i];
            
            //Every 4th second, check whether the spawn site's health is 3/4 - 4/4
            if(
                lapsedTime % (dayOfTimeFactor * UndeadInvasion::RulesVariables::UNDEAD_SPAWN_INTERVAL_1 * getTicksASecond()) == 0 
                && spawnSite.getHealth() >=(spawnSite.getInitialHealth() * 3/4)) {
              
              spawnUndead(this, spawnSite.getPosition());
              
            }
            
            //Every 3rd second, check whether the spawn site's health is 2/4 - 3/4
            else if(
                lapsedTime % (dayOfTimeFactor * UndeadInvasion::RulesVariables::UNDEAD_SPAWN_INTERVAL_2 * getTicksASecond()) == 0 
                && spawnSite.getHealth() >=(spawnSite.getInitialHealth() * 2/4)
                && spawnSite.getHealth() < (spawnSite.getInitialHealth() * 3/4)) {
              
              spawnUndead(this, spawnSite.getPosition());
              
            }
            
            //Every 2nd second, check whether the spawn site's health is 1/4 - 2/4
            else if(
                lapsedTime % (dayOfTimeFactor * UndeadInvasion::RulesVariables::UNDEAD_SPAWN_INTERVAL_3 * getTicksASecond()) == 0 
                && spawnSite.getHealth() >=(spawnSite.getInitialHealth() * 1/4)
                && spawnSite.getHealth() < (spawnSite.getInitialHealth() * 2/4)) {
              
              spawnUndead(this, spawnSite.getPosition());
              
            }
            
            //Every second, check whether the spawn site's health is below 2/4
            else if(spawnSite.getHealth() < (spawnSite.getInitialHealth() * 1/4)) {
            
              spawnUndead(this, spawnSite.getPosition());
              
            }
          
          
          }
          
          //Finished this iteration
          
        }
      
      }
          
    } //End method
    
    
    
    /**
     * Checks if all teams have enough players.
     * Variables: PLAYER_COUNT_START_MINIMUM
     */
    bool allTeamsHaveEnoughPlayers(CRules@ this) {
    
      //Retrieve minimum player count variable
      s8 playerCountMinimum = 
        UndeadInvasion::RulesVariables::PLAYER_COUNT_START_MINIMUM;
      
      //Check if player count minimum is not disabled (negative number)
      if(playerCountMinimum >= 0) {
      
        //Finished, return result from other version of this method
        return allTeamsHaveNumberOfPlayers(this, playerCountMinimum);
        
      }
      
      //Otherwise, player count minimum disabled
      else {
      
        //Finished, return result from survivor team check
        return survivorTeamsHaveEnoughPlayers(this);
      
      }
      
    } //End method
    
    
    
    /**
     * Checks if all teams have at least a certain number of player(s).
     * 
     * @param   number    minimum number of players.
     */
    bool allTeamsHaveNumberOfPlayers(CRules@ this, int number)	{
      
      //Iterate through all teams
      for(int i = 0; i < this.getTeamsCount(); i++) {
        
        //Check if team has less than one player
        if(UndeadInvasion::getPlayersCount(i) < number) {
          
          //Finished, this team does not have enough players
          return false;
          
        }
        
      }
      
      //Finished, no teams were found to not have enough players
      return true;
      
    } //End method
    
    
    
    /**
     * Checks if there's a survivor team and that the minimum number of survivors are present.
     */
    bool survivorTeamsHaveEnoughPlayers(CRules@ this) {
      
      //Finished, return result from other version of this method
      return survivorTeamsHaveEnoughPlayers(
          this
        , UndeadInvasion::RulesVariables::SURVIVOR_COUNT_START_MINIMUM
      );
    
    } //End method
    
    
    
    /**
     * Checks if there's a survivor team and number of members exceeds the criteria
     * 
     * @param   number    number criteria.
     */
    bool survivorTeamsHaveEnoughPlayers(CRules@ this, int number) {
    
      CTeam@ team;
      
      //Iterate through all teams
      for(int i = 0; i < this.getTeamsCount(); i++) {
        
        @team = this.getTeam(i);
      
        //Check if not undead team and player count is enough
        if(
             team.getName().find("Survivor") != -1
          && UndeadInvasion::getPlayersCount(i) >= number
        ) {
          
          //Finished, enough players in survivor team
          return true;
          
        }
      
      }
      
      //Finished, survivor team not present or empty
      return false;
    
    } //End method
    
    
    
    /**
     * Checks if any team has any survivors
     */
    bool anyTeamHasPlayers(CRules@ this) {
      
      //Iterate through all teams
      for(int i=0; i<this.getTeamsCount(); i++) {
        
        //Check if team has any players
        if(UndeadInvasion::getPlayersCount(i) > 0) {
          
          //Finished, this team has at least one player
          return true;
          
        }
        
      }
      
      //Finished, no team were found to have any players
      return false;
      
    } //End method
    
    
    
    /**
     * Checks if any team has any survivors
     */
    bool anySurvivorTeamHasPlayersAlive(CRules@ this) {
    
      CTeam@ team;
    
      //Iterate through all teams
      for(int i=0; i<this.getTeamsCount(); i++) {
        
        @team = this.getTeam(i);
        
        //Check if not undead team
        if(team.getName() != "Undead team") {
        
          CPlayer@ player;
          
          //Iterate through all players
          for(int j=0; j<::getPlayersCount(); j++) {
          
            @player = getPlayer(j);
            
            //Check if player is on this team and isn't tagged as dead
            if(player.getTeamNum() == i) {
            
              //Obtain a reference to this player's blob
              CBlob@ survivorBlob = player.getBlob();
              
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
      
    } // End method
    
    
    
    /**
     * Spawns an undead CreatureBlob in a given place
     */
    void spawnUndead(CRules@ this, Vec2f position) {
    
      u8 undeadCountAvailable
        = this.get_u8("UndeadInvasion::Rules::undeadCountAvailable");
    
      //Check if there are any undead available for spawning
      if(undeadCountAvailable > 0) {
      
        //Get a random value between 0 and 100
        u8 randomChance = XORRandom(100);
        
        //Get a reference to the spawn mix array
        UndeadInvasion::EntitySpawn[] spawnMix 
          = UndeadInvasion::RulesVariables::UNDEAD_ENTITY_SPAWN_MIX;
        
        //Create an entity spawn object handle
        UndeadInvasion::EntitySpawn spawn;
        
        //Keep track of accumulated spawn chance
        u8 accumulatedChance = 0;
        
        //Iterate through all entity spawn objects (think: percentage pie chart)
        for(u8 i=0; i<spawnMix.length; i++) {
        
          //Keep a reference to this entity spawn object
          spawn = UndeadInvasion::RulesVariables::UNDEAD_ENTITY_SPAWN_MIX[i];
          
          //Check if random chance value is within this window
          if(randomChance > accumulatedChance && randomChance < accumulatedChance + spawn.mSpawnChance) {
          
            //Spawn this entity
            server_CreateBlob(spawn.mEntityName, -1, position);
            
            //Reduce available undead for spawning
            this.set_u8(
                "UndeadInvasion::Rules::undeadCountAvailable"
              , undeadCountAvailable - 1
            );
            
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
    
      CBlob@[]    survivorSpawnSites;
      CBlob@      spawnSite;
      CBlob@      crate;
      CBlob@      material;
      
      //Retrieve references to all survivor spawn sites
      getBlobsByTag("isSurvivorSpawn", @survivorSpawnSites);

      //Iterate over all survivor spawn sites
      for(int i=0; i<survivorSpawnSites.length; i++) {

        //Keep a reference to the spawn site blob object
        @spawnSite = survivorSpawnSites[i];
        
        //Create crate (MakeCrate.as)
        @crate = server_MakeCrateOnParachute(
            ""                                        //blobName
          , ""                                        //inventoryName
          , 5                                         //frameIndex
          , spawnSite.getTeamNum()                    //team
          , getDropPosition(spawnSite.getPosition())  //pos
        );
        
        //Continue, if valid reference
        if(crate !is null) {
        
          //Enable unpack button
          crate.Tag("unpackall");
          
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