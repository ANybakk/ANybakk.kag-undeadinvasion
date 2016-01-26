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
  
  //Define a factor for movement in water of 0.23 horizontal, 0.23 vertical
	const Vec2f MOVEMENT_FACTOR_WATER(0.23f, 0.23f);
  
  //Define a factor for slowing down of 2.0 horizontal, 0.0 vertical
	const Vec2f MOVEMENT_FACTOR_SLOWDOWN(2.0f, 0.0f);
  
  //Define a maximum velocity of 0.5
	const f32 MOVEMENT_MAX_VELOCITY = 0.5f;
  
  //Define a walking acceleration of 4.0 horizontal, 0.0 vertical
  const Vec2f MOVEMENT_WALK_ACCELERATION(4.0f, 0.0f);
  
  //Define a running acceleration of 4.0 horizontal, 0.0 vertical
	const Vec2f MOVEMENT_RUN_ACCELERATION(4.0f, 0.0f);
  
  //Define a walking acceleration of 0.0 horizontal, -1.6 vertical
	const Vec2f MOVEMENT_JUMP_ACCELERATION(0.0f, -1.6f);
  
}