class_name Jump
extends BaseState

@export var jump_force: float = 300#285.0
@export var move_speed: float = 60.0
@export var shoot_anim: String = "jump_shoot"


@onready var muzzle: Node2D = $JumpShootMuzzle #TODO
#@onready var jump_shoot_muzzle: Node2D = $JumpShootMuzzle

func enter() -> void:
	super()
	
	player.velocity.y = -jump_force

func input(_event: InputEvent) -> int:  
	super(_event)
	
	# We need to deccelerate if the player released the jump button
	# TODO but consider if we should have a minimum jump
	if Input.is_action_just_released("jump"):
		player.velocity.y = 0
		#return State.Fall
	
	# I had originally thought to add a "jump_shoot" state but really nothing changes
	#	in terms of behavior, so I chose to put it here.
	#	I feel it should return to jumping withuot the cannon maybe but TODO
	if Input.is_action_just_pressed("shoot"):
		player.animations.play("jump_shoot")
		shoot(muzzle)
	
	return State.Null


func physics_process(_delta: float) -> int:
	
	player.velocity.x = player.direction * player.is_moving_horizontal * move_speed
	player.velocity.y += player.gravity
	
	player.move_and_slide()
	
	#if player.velocity.y > 0:
		#return State.Fall
		
	if player.is_on_floor():
		return State.Idle
	
	return State.Null
