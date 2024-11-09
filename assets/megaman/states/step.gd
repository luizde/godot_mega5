extends BaseState

var _internal_state: int = State.Step

# In Step, we will only go into enter, move the distance and wait to call either Idle or Walk
func enter() -> void:
	super()
	
	_internal_state = State.Step
	
	#player.animations.frame = 0
	player.animations.play(animation_name)
	
	# Move one pixel in either direction to make the step be felt
	player.position.x += 1 * player.direction
	
	player.animations.speed_scale = 20 #otherwise signal takes a while

# This is necessary just to get out of here after the signal
# it causes a slight delay because we don't come here right after the signal
# but rather wait for the next _physics_process. 
# At 60fps its a very acceptable error hopefully
func physics_process(_delta: float) -> int:
	super(_delta)
	
	if _internal_state != State.Step:
		return _internal_state
	if !player.is_on_floor():
		player.velocity.y = 0
		return State.Fall
	
	return State.Null

# The step happened, we changed positions, let's now leave the state
# Maybe this check can happen on physics_process, but this lets us do small steps
# 	without a very immediate transition
func _on_animated_sprite_2d_animation_finished() -> void:
	if player.animations.animation == "step":
		player.animations.speed_scale = 1
		if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
			_internal_state = State.Walk
		elif Input.is_action_pressed("jump"):
			_internal_state = State.Jump
		else:
			_internal_state = State.Idle
	
