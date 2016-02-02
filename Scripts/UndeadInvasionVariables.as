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

namespace UndeadInvasionVariables {
  
  //Define a spawning interval of 4 seconds for top quarter of spawn site health
  const u8 UNDEAD_SPAWN_INTERVAL_1 = 4;
  
  //Define a spawning interval of 3 seconds for third quarter of spawn site health
  const u8 UNDEAD_SPAWN_INTERVAL_2 = 3;
  
  //Define a spawning interval of 2 seconds for second quarter of spawn site health
  const u8 UNDEAD_SPAWN_INTERVAL_3 = 2;
  
  //Define a spawning interval of 1 second for first quarter of spawn site health
  const u8 UNDEAD_SPAWN_INTERVAL_4 = 1;
  
  //Define an undead spawning factor during daytime of 2 (double interval)
  const u8 UNDEAD_SPAWN_DAYTIMEFACTOR = 2;
  
  //Define an undead spawning factor during daytime of 2 (base interval)
  const u8 UNDEAD_SPAWN_NIGHTTIMEFACTOR = 1;
  
}