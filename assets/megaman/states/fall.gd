extends BaseState

func enter() -> void:
	super()
	
func input(_event: InputEvent) -> int:  
	super(_event)
	
	if player.is_on_ladder and Input.is_action_just_pressed("move_down"):
		player.position = player.ladder_touched_position
		return State.Ladder
	
	# I had originally thought to add a "jump_shoot" state but really nothing changes
	#	in terms of behavior, so I chose to put it here.
	#	I feel it should return to jumping withuot the cannon maybe but TODO
	if Input.is_action_just_pressed("shoot") \
				or (Input.is_action_just_released("shoot") and player.charge_time > 0.0 \
				and player.charge_level > BaseBullet.BULLET_TYPE.NORMAL):
		player.shoot(Vector2(muzzle_position_relative_x, muzzle_position_relative_y))
		player.animations.play("jump_shoot")
		
	
	return State.Null


func physics_process(_delta: float) -> int:
	super(_delta)
	
	# We cap velocity at 420 px per sec or 7px per frame
	if WorldPhysics.gravity > 0:
		if player.velocity.y >= WorldPhysics.gravity * 60:
			player.velocity.y = WorldPhysics.gravity * 60
		else:
			player.velocity.y += WorldPhysics.gravity
	else:
		if player.velocity.y <= WorldPhysics.gravity * 60:
			player.velocity.y = WorldPhysics.gravity * 60
		else:
			player.velocity.y += WorldPhysics.gravity
	
	player.velocity.x = player.direction * player.is_moving_horizontal * player.speed 
	
	#TODO: maybe reconsider and use move_and_collide. The downside is we need to create
	# 		our own is_on_floor, but we get more control and physics are easily defined here
	player.move_and_slide()
	
	if player.is_on_floor():
		return State.Idle
	
	#if player.velocity.y > 0:
		#return State.Fall
	
	return State.Null
