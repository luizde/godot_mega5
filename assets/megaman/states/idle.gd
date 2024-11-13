class_name Idle
extends BaseState

var lower_cannon_idle: Timer

@export var shoot_animation: String = "idle_shoot"

func enter() -> void:
	super()
		
	# not sure why the to below don't work @onready
	# probably something related to Idle being the first state to be used when 
	# the game begins or about order of instantiation between parents and children
	lower_cannon_idle = $LowerCannonIdle
	

func input(_event: InputEvent) -> int:
	var ret = super(_event)
	#super(_event)
	if ret != State.Null:
		return ret
	#TODO: this doesn't work due to colliders and move_and_slide()
	#TODO: consider on ladders move without physics engine?
	#if player.is_on_ladder and Input.is_action_just_pressed("move_up"):
		#player.position = player.ladder_touched_position
		#return State.Ladder
		
	if Input.is_action_just_pressed("move_right") or Input.is_action_just_pressed("move_left"):
		return State.Step
	
	# If we put slide before jump, we avoid one check on Jump's if
	if WorldPhysics.gravity > 10: #gravity goes down
		if Input.is_action_pressed("move_down") and Input.is_action_just_pressed("jump"):
			return State.Slide
	else:
		if Input.is_action_pressed("move_up") and Input.is_action_just_pressed("jump"):
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
	
	
