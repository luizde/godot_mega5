class_name Idle
extends BaseState

var muzzle: Node2D
var lower_cannon_idle: Timer

@export var shoot_animation: String = "idle_shoot"

func enter() -> void:
	super()
	
	# not sure why the to below don't work @onready
	# probably something related to Idle being the first state to be used when 
	# the game begins or about order of instantiation between parents and children
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
	
	if Input.is_action_just_pressed("shoot") \
				or (Input.is_action_just_released("shoot") and player.charge_time > 0.0 \
				and player.charge_level > BaseBullet.BULLET_TYPE.NORMAL):
		player.shoot(Vector2(muzzle_position_relative_x, muzzle_position_relative_y))
		player.animations.play(shoot_animation)
		lower_cannon_idle.start()
	
	return State.Null

func physics_process(_delta: float) -> int:
	super(_delta)
	
	if Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left"):
		return State.Step
	
	if !player.is_on_floor():
		player.velocity.y = 0
		return State.Fall
	
	return State.Null

func _on_lower_cannon_idle_timeout() -> void:
	#print(player.states.current_state)
	player.animations.play(animation_name)
	
func exit() -> void:
	# The timer that calls back the lower fire could be running. Stop it.
	lower_cannon_idle.stop()
	
	
