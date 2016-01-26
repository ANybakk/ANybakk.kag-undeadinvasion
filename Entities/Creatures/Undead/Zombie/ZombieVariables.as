/*
 * UndeadInvasion Zombie variables
 * 
 * This script contains any variables associated with the entity. To override 
 * these variables, make a new mod where you override this file. By doing it 
 * this way, tweaking these variables won't require having to deal with code.
 * 
 * Author: ANybakk
 */

namespace ZombieVariables {

  //Define a rotting time of 5 seconds
  const u8 ROTTING_TIME = 5;
  
  //Define a delay of 5 frames
  const u8 BRAIN_DELAY = 5; //TODO: Define in terms of seconds (float)

  //Define a target radius of 32.0
  const f32 BRAIN_TARGET_RADIUS = 32.0f;

  //Define an attack frequency of 2 seconds
  const u8 BRAIN_ATTACK_FREQUENCY = 2;
  
  //Define a factor for movement in water (horizontal)
  const f32 MOVEMENT_FACTOR_WATER_X = 0.23f;
  
  //Define a factor for movement in water (vertical)
  const f32 MOVEMENT_FACTOR_WATER_Y = 0.23f;
  
}