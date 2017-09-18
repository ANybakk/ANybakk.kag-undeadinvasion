// Bed

#include "Help.as" //?

const f32 heal_amount = 0.25f;
const u8 heal_rate = 30;

void onInit( CBlob@ this )
{		 	
	this.getShape().getConsts().mapCollisions = false;

	AttachmentPoint@ bed = this.getAttachments().getAttachmentPointByName("BED");
	if (bed !is null)
	{
		bed.SetKeysToTake(key_left | key_right | key_up | key_down | key_action1 | key_action2 | key_action3 | key_pickup | key_inventory);
		bed.SetMouseTaken(true);
	}

	this.addCommandID("rest");
	this.getCurrentScript().runFlags |= Script::tick_hasattached;

	// ICONS
	AddIconToken("$rest$", "InteractionIcons.png", Vec2f(32, 32), 29);

	this.getCurrentScript().tickFrequency = 179;
	
	this.Tag("dead head");

}

void onTick( CBlob@ this )
{

	// TODO: Add stage based sleeping, rest(2 * 30) | sleep(heal_amount * (patient.getHealth() - patient.getInitialHealth())) | awaken(1 * 30)
	// TODO: Add SetScreenFlash(rest_time, 19, 13, 29) to represent the player gradually falling asleep
	bool isServer = getNet().isServer();
	AttachmentPoint@ bed = this.getAttachments().getAttachmentPointByName("BED");
	if (bed !is null)
	{
		CBlob@ patient = bed.getOccupied();
		if (patient !is null)
		{
			if (bed.isKeyJustPressed(key_up))
			{
				if (isServer)
				{
					patient.server_DetachFrom(this);
				}
			}
			else if (getGameTime() % heal_rate == 0)
			{
				if (requiresTreatment(patient))
				{
					if (patient.isMyPlayer())
					{
						Sound::Play("Heart.ogg", patient.getPosition());
					}
					if (isServer)
					{
						patient.server_Heal(heal_amount);
					}
				}
				else
				{
					if (isServer)
					{
						patient.server_DetachFrom(this);
					}
				}
			}
		}
	}
}

void onCommand( CBlob@ this, u8 cmd, CBitStream @params )
{

	bool isServer = getNet().isServer();
	CSprite@ sprite = this.getSprite();

	if (cmd == this.getCommandID("setOccupied"))
	{	
		sprite.SetFrame(1);
		sprite.getSpriteLayer( "zzz" ).SetVisible( true );
	}

	else if (cmd == this.getCommandID("unsetOccupied"))
	{	
		sprite.SetFrame(0);
		sprite.getSpriteLayer( "zzz" ).SetVisible( false );
	}

	else if (cmd == this.getCommandID("rest"))
	{
		u16 caller_id;
		if (!params.saferead_netid(caller_id))
			return;

		CBlob@ caller = getBlobByNetworkID(caller_id);
		if (caller !is null)
		{
			AttachmentPoint@ bed = this.getAttachments().getAttachmentPointByName("BED");
			if (bed !is null)
			{
				CBlob@ carried = caller.getCarriedBlob();
				if (isServer)
				{
					if (carried !is null)
					{
						if (!caller.server_PutInInventory(carried))
						{
							carried.server_DetachFrom(caller);
						}
					}
					this.server_AttachTo(caller, "BED");
				}
			}
		}
		
	}
	
	else if (cmd == this.getCommandID("shop buy")){
          sprite.PlaySound("/ConstructShort");
        }
}

void GetButtonsFor(CBlob@ this, CBlob@ caller) {
																							CBitStream params;
	params.write_u16(caller.getNetworkID());
	caller.CreateGenericButton("$rest$", Vec2f(-6, 0), this, this.getCommandID("rest"), "Rest", params);																			
}

void onAttach(CBlob@ this, CBlob@ attached, AttachmentPoint@ attachedPoint)
{
	attached.getShape().getConsts().collidable = false;
	attached.SetFacingLeft(true);
	attached.AddScript("WakeOnHit.as");

	if (not getNet().isClient()) return;

	CSprite@ sprite = this.getSprite();

	if (sprite is null) return;

	updateLayer(sprite, "bed", 1, true, false);
	updateLayer(sprite, "zzz", 0, true, false);

	sprite.SetEmitSoundPaused(false);
	sprite.RewindEmitSound();

	CSprite@ attached_sprite = attached.getSprite();

	if (attached_sprite is null) return;

	attached_sprite.SetVisible(false);
	attached_sprite.PlaySound("GetInVehicle.ogg");

	CSpriteLayer@ head = attached_sprite.getSpriteLayer("head");

	if (head is null) return;

	Animation@ head_animation = head.getAnimation("default");

	if (head_animation is null) return;

	CSpriteLayer@ bed_head = sprite.addSpriteLayer("bed head", head.getFilename(),
		16, 16, attached.getTeamNum(), attached.getSkinNum());

	if (bed_head is null) return;

	Animation@ bed_head_animation = bed_head.addAnimation("default", 0, false);

	if (bed_head_animation is null) return;

	bed_head_animation.AddFrame(head_animation.getFrame(2));

	bed_head.SetAnimation(bed_head_animation);
	bed_head.RotateBy(80, Vec2f_zero);
	bed_head.SetOffset(Vec2f(1, 2));
	bed_head.SetFacingLeft(true);
	bed_head.SetVisible(true);
	bed_head.SetRelativeZ(2);
}

void onDetach(CBlob@ this, CBlob@ detached, AttachmentPoint@ attachedPoint)
{
	detached.getShape().getConsts().collidable = true;
	detached.AddForce(Vec2f(0, -20));
	detached.RemoveScript("WakeOnHit.as");

	CSprite@ detached_sprite = detached.getSprite();
	if (detached_sprite !is null)
	{
		detached_sprite.SetVisible(true);
	}

	CSprite@ sprite = this.getSprite();
	if (sprite !is null)
	{
		updateLayer(sprite, "bed", 0, true, false);
		updateLayer(sprite, "zzz", 0, false, false);
		updateLayer(sprite, "bed head", 0, false, true);

		sprite.SetEmitSoundPaused(true);
	}
}

void updateLayer(CSprite@ sprite, string name, int index, bool visible, bool remove)
{
	if (sprite !is null)
	{
		CSpriteLayer@ layer = sprite.getSpriteLayer(name);
		if (layer !is null)
		{
			if (remove == true)
			{
				sprite.RemoveSpriteLayer(name);
				return;
			}
			else
			{
				layer.SetFrameIndex(index);
				layer.SetVisible(visible);
			}
		}
	}
}

bool bedAvailable(CBlob@ this)
{
	AttachmentPoint@ bed = this.getAttachments().getAttachmentPointByName("BED");
	if (bed !is null)
	{
		CBlob@ patient = bed.getOccupied();
		if (patient !is null)
		{
			return false;
		}
	}
	return true;
}

bool requiresTreatment(CBlob@ caller)
{
	return caller.getHealth() < caller.getInitialHealth();
}


// SPRITE

void onInit(CSprite@ this)
{
	this.SetZ(-50); //background
	this.SetFrame(0);

	CSpriteLayer@ zzz = this.addSpriteLayer( "zzz", 8,8 );		 
	if (zzz !is null)
	{
		zzz.addAnimation("default",3,true);
		int[] frames = {7,14,15};
		zzz.animation.AddFrames(frames);
		zzz.SetOffset(Vec2f(-7 * (this.getBlob().isFacingLeft() ? -1.0f : 1.0f),-7));
		zzz.SetVisible( false );
		zzz.SetLighting( false );
		zzz.SetHUD( true );
	}

	this.SetEmitSound("MigrantSleep.ogg");
	this.SetEmitSoundPaused(true);
	this.SetEmitSoundVolume(0.5f);
}
