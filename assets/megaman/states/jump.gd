## State class for Jumping and Falling (falling is just a special case of jump)
class_name Jump
extends BaseState

@export var shoot_anim: String = "jump_shoot"

func enter() -> void:
	super()
	
	if Input.is_action_just_pressed("jump"):
		player.velocity.y = player.jump_force

func input(_event: InputEvent) -> int:  
	super(_event)
	
	if player.is_on_ladder and (Input.is_action_just_pressed("move_down") or Input.is_action_just_pressed("move_down")):
		player.position = player.ladder_touched_position
		return State.Ladder
	
	# We need to deccelerate if the player released the jump button
	# 	we need to check that velocity is still less than zero. Otherwise, 
	#	turning the velocity of Y to zero causes deceleration of falll
	if Input.is_action_just_released("jump"):# and player.velocity.y < 0:
		#player.velocity.y = 0
		return State.Fall
	
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
	
	player.velocity.x = player.direction * player.is_moving_horizontal * player.speed
	#player.velocity.y += WorldPhysics.gravity
	
	player.move_and_slide()
	
	#if player.velocity.y > 0:
		#return State.Fall
		
	if player.is_on_floor():
		return State.Idle
	
	return State.Null
