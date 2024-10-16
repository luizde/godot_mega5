class_name Idle
extends BaseState

var muzzle: Node2D
var lower_cannon_idle: Timer

@export var shoot_animation: String = "idle_shoot"

func enter() -> void:
	super()
	
	# not sure why the to below don't work @onready
	# probably something related to Idle being the first state to be used when 
	# the game begins
	muzzle = $IdleShootMuzzle
	lower_cannon_idle = $LowerCannonIdle
	

func input(_event: InputEvent) -> int:
	super(_event)
	
	if Input.is_action_just_pressed("damage_test"):
		return State.Damaged
	
	if Input.is_action_just_pressed("move_right") or Input.is_action_just_pressed("move_left"):
		return State.Step
	
	# If we put slide before jump, we avoid one check on Jump's if
	if Input.is_action_pressed("move_down") and Input.is_action_just_pressed("jump"):
		return State.Slide
	
	if Input.is_action_just_pressed("jump"):
		return State.Jump
	
	if Input.is_action_just_pressed("shoot"):
		shoot(muzzle)
		player.animations.play(shoot_animation)
		lower_cannon_idle.start()
		#return State.IdleShoot
	
	return State.Null

func physics_process(_delta: float) -> int:
	if Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left"):
		return State.Step
	
	if !player.is_on_floor():
		return State.Fall
	
	return State.Null

func _on_lower_cannon_idle_timeout() -> void:
	player.animations.play(animation_name)
	
