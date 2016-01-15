/*
 * UndeadInvasion Zombie
 * 
 * Author: ANybakk
 * Based on previous work by: Eanmig
 * 
 * TODO: Instead of corpsifying the zombie and adding health to it, turn it into a pile of gibs block (unless it was killed with explosives)
 */

#include "Hitters.as";



//Define a rotting time of 5 seconds
const u8 zombie_rotting_time = 5;



/**
 * Initialization event function
 */
void onInit(CBlob@ this) {
  
  //Set rotting time variable
  this.set_u8("zombie_rotting_time", zombie_rotting_time*getTicksASecond());
  
  //Set time of death variable
  this.set_u16("time_of_death", 0);

}



/**
 * Tick event function
 */
void onTick(CBlob@ this) {

  //Retrieve horizontal velocity
  //f32 x = this.getVelocity().x;

  //Check if zombie's health is depleted and is currently alive
  if(this.getHealth()<=0.0 && this.get_u16("time_of_death") == 0) {
  
    //Set health to 0.5 (keep alive)
    this.server_SetHealth(0.5);
    
    //Set time of death variable
    this.set_u16("time_of_death", getGameTime());
    
    //Set shape friction to 0.3
    this.getShape().setFriction( 0.3f );
    
    //Set shape elasticity to 0.1
    this.getShape().setElasticity( 0.1f );
    
  }
  
  //If zombie has been dead for more than set rotting time
  if(getGameTime() - this.get_u16("time_of_death")) < this.get_u8("zombie_rotting_time")) {
  
    //Let zombie die (or turn into pile of gibs block)
    
    
  }

  
  
  
  
  
  float difficulty = getRules().get_f32("difficulty");
  int break_chance = 30 - 2*(difficulty-1.0);
  if (break_chance<10) break_chance=10;
  
  
/* Redundant?
	if (Maths::Abs(x) > 1.0f)
	{
		this.SetFacingLeft( x < 0 );
	}
	else
	{
		if (this.isKeyPressed(key_left)) {
			this.SetFacingLeft( true );
		}
		if (this.isKeyPressed(key_right)) {
			this.SetFacingLeft( false );
		}
	}
  */



	/* Purpose?
	if(getNet().isServer() && getGameTime() % 10 == 0)
	{
		if(this.get_u8(state_property) == MODE_TARGET )
		{
			CBlob@ b = getBlobByNetworkID(this.get_netid(target_property));
			if(b !is null && this.getDistanceTo(b) < 106.0f)
			{
				this.Tag(chomp_tag);
			}
			else
			{
				this.Untag(chomp_tag);
			}
		}
		else
		{
			this.Untag(chomp_tag);
		}
		this.Sync(chomp_tag,true);
	}
	*/
  
}



f32 onHit( CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitterBlob, u8 customData )
{		

  //Target player
  //TODO

	if (this.getHealth()>0 && this.getHealth() <= damage)
	{
		if (getNet().isServer())
		this.set_u16("time_of_death", getGameTime());
		this.Sync("time_of_death", true); //?
	}
	if (customData == Hitters::arrow) damage*=2.0;
    this.Damage( damage, hitterBlob );
    // Gib if health below gibHealth
    f32 gibHealth = getGibHealth( this );
	
	//printf("ON HIT " + damage + " he " + this.getHealth() + " g " + gibHealth );
    // blob server_Die()() and then gib

	
	//printf("gibHealth " + gibHealth + " health " + this.getHealth() );
    if (this.getHealth() <= gibHealth)
    {
        this.getSprite().Gib();
		if (hitterBlob.hasTag("player"))
		{
			CPlayer@ player = hitterBlob.getPlayer();
			//player.server_setCoins( player.getCoins() + 10 );		
		} else
		if(hitterBlob.getDamageOwnerPlayer() !is null)
		{
			CPlayer@ player = hitterBlob.getDamageOwnerPlayer();
			//player.server_setCoins( player.getCoins() + 10 );		
		}
		server_DropCoins(hitterBlob.getPosition() + Vec2f(0,-3.0f), 10);
		
        this.server_Die();
    }
		
    return 0.0f; //done, we've used all the damage	
	
}



/**
 * pickup check function
 */
bool canBePickedUp(CBlob@ this, CBlob@ other) {

  //Determine if zombie has health left or if zombie is on the same team
  //return this.getHealth() < 0.0 || this.getTeamNum() == other.getTeamNum();
  
  return false;
  
  //Finished
  
}



f32 getGibHealth( CBlob@ this )
{
    if (this.exists("gib health")) {
        return this.get_f32("gib health");
    }

    return 0.0f;
}

								



bool doesCollideWithBlob( CBlob@ this, CBlob@ blob )
{
	if (blob.hasTag("dead"))
		return false;
	if (!blob.hasTag("zombie") && blob.hasTag("flesh") && this.getTeamNum() == blob.getTeamNum()) return false;
	if (blob.hasTag("zombie") && blob.getHealth()<0.0) return false;
	return true;
}

void onCollision( CBlob@ this, CBlob@ blob, bool solid, Vec2f normal, Vec2f point1 )
{
	if (this.getHealth() <= 0.0) return; // dead
	if (blob is null)
		return;

	const u16 friendId = this.get_netid(friend_property);
	CBlob@ friend = getBlobByNetworkID(friendId);
	if (blob.getTeamNum() != this.getTeamNum() && blob.hasTag("flesh") && !blob.hasTag("dead"))
	{
		MadAt( this, blob );
	}
}

void onHitBlob( CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitBlob, u8 customData )
{
/*	if (hitBlob !is null)
	{
		Vec2f force = velocity * this.getMass() * 0.35f ;
		force.y -= 1.0f;
		hitBlob.AddForce( force);
	}*/
}


void dropHeart( CBlob@ this )
{
    if (!this.hasTag("dropped heart")) //double check
    {
        CPlayer@ killer = this.getPlayerOfRecentDamage();
        CPlayer@ myplayer = this.getDamageOwnerPlayer();

        if (killer is null || ((myplayer !is null) && killer.getUsername() == myplayer.getUsername())) { return; }

        this.Tag("dropped heart");

        if ((XORRandom(1024) / 1024.0f) < 0.25)
        {
            CBlob@ heart = server_CreateBlob( "heart", -1, this.getPosition() );

            if (heart !is null)
            {
                Vec2f vel( XORRandom(2) == 0 ? -2.0 : 2.0f, -5.0f );
                heart.setVelocity(vel);
            }
        }
    }
}

void dropArm( CBlob@ this )
{
    {
        if ((XORRandom(1024) / 1024.0f) < 0.5)
        {
			CBlob @zombieArm = server_CreateBlob( "ZombieArm", -1, this.getPosition());
            if (zombieArm !is null)
            {
                Vec2f vel( XORRandom(2) == 0 ? -2.0 : 2.0f, -5.0f );
                zombieArm.setVelocity(vel);
				warn("spawn arm");
            }
        }
    }
}

void onDie( CBlob@ this )
{