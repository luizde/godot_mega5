extends BaseState

@onready var _ladder_direction = 1
var _first_frame: bool = true

func enter() -> void:
	super()
	player.velocity.x = 0
	player.velocity.y = 0
	player.animations.stop()
	_first_frame = true
	GodotLogger.debug("Entered Ladder State")
	
func input(_event: InputEvent) -> int:  
	
	if Input.is_action_pressed("shoot"):
		player.charging = true
	
	if Input.is_action_just_released("shoot"):
		#player.charge_time = 0
		player.charging = false
		
	if Input.is_action_pressed("move_up"):
		_ladder_direction = 1
		player.animations.play()
	elif Input.is_action_pressed("move_down"):
		_ladder_direction = -1
		player.animations.play()
	else:
		_ladder_direction = 0
	
	if (Input.is_action_just_released("move_up") and !Input.is_action_pressed("move_down")) or \
			 (Input.is_action_just_released("move_down") and !Input.is_action_pressed("move_up")):
		player.animations.stop()
	
	if Input.is_action_just_pressed("jump"):
		return State.Fall
	
	
	## TODO: let him shoot
	#if Input.is_action_just_pressed("shoot") \
				#or (Input.is_action_just_released("shoot") and player.charge_time > 0.0 \
				#and player.charge_level > BaseBullet.BULLET_TYPE.NORMAL):
		#player.shoot(Vector2(muzzle_position_relative_x, muzzle_position_relative_y))
		#player.animations.play("jump_shoot")
		
	
	return State.Null



func physics_process(_delta: float) -> int:
	super(_delta)
	
	if _first_frame:
		_first_frame = false
		# We do the adjustment cause we processed one frame after the detection happened
		# Therefore acceleration incremented by a factor of gravity
		player.position.y -= (abs(player.ladder_velocity_before_touch) + abs(WorldPhysics.gravity)) * _delta
	
	if !player.is_on_ladder:
		return State.Fall
	
	player.velocity.y = _ladder_direction * player.speed 
	
	#TODO: maybe reconsider and use move_and_collide. The downside is we need to create
	# 		our own is_on_floor, but we get more control and physics are easily defined here
	player.move_and_slide()
	
	#if player.velocity.y > 0:
		#return State.Fall
	
	return State.Null
