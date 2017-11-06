/*
 * UndeadInvasion game mode variables
 * 
 * This script contains any variables associated with the game mode.
 * 
 * NOTE: To simply tweak variables on a server, create a new mod containing a 
 *       copy of this file with the same name.
 * 
 * NOTE: Scripts may rely on these variables. When overriding 
 *       these values or creating new entities based on this one, bundle this 
 *       file, or a derived version, together with any scripts used.
 * 
 * Author: ANybakk
 */

#include "[UndeadInvasion]EntitySpawn.as";


 
namespace UndeadInvasion {

  namespace RulesVariables {
  
  
  
    //Minimum number of players on each team for the game to start
    const s8 PLAYER_COUNT_START_MINIMUM = -1; //Disabled
    
    //Minimum number of survivors for the game to start
    const u8 SURVIVOR_COUNT_START_MINIMUM = 1;

    //Maximum number of undead
    const u8 UNDEAD_SPAWN_MAX_COUNT = 125;
    
    //Spawning interval for top quarter of spawn site health (seconds)
    const u8 UNDEAD_SPAWN_INTERVAL_1 = 4;
    
    //Spawning interval for third quarter of spawn site health (seconds)
    const u8 UNDEAD_SPAWN_INTERVAL_2 = 3;
    
    //Spawning interval for second quarter of spawn site health (seconds)
    const u8 UNDEAD_SPAWN_INTERVAL_3 = 2;
    
    //Spawning interval for lowest quarter of spawn site health (seconds)
    const u8 UNDEAD_SPAWN_INTERVAL_4 = 1;
    
    //Undead spawning factor during daytime (multiplier)
    const u8 UNDEAD_SPAWN_DAYTIMEFACTOR = 2; //Double interval
    
    //Undead spawning factor during nighttime (multiplier)
    const u8 UNDEAD_SPAWN_NIGHTTIMEFACTOR = 1; //Base interval
    
    //Undead entities to spawn
    const UndeadInvasion::EntitySpawn[] UNDEAD_ENTITY_SPAWN_MIX = {
        UndeadInvasion::EntitySpawn("Zombie"          , 60),  //Zombie 60% chance
      , UndeadInvasion::EntitySpawn("Skeleton"        , 35),  //Skeleton 35% chance
      , UndeadInvasion::EntitySpawn("Devilish Zombie" ,  5)   //Devilish Zombie 5% chance
    };
    
    //Cooldown between game over and next map (in seconds)
    const u16 NEXT_MAP_COOLDOWN = 5;
    
    
    
  }
  
}