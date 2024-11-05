extends BaseState

@export var sliding_speed: float = 150.0
@onready var slide_timer: Timer = $SlideTimer

var _next_state: int = BaseState.State.Null

func enter() -> void:
	super()
	
	slide_timer.start()
	_next_state = BaseState.State.Null
	
	EventBus.player_sliding_start.emit()
	
	# Change to the horitzontal collider
	player.standing_collider.set_deferred("disabled", true)
	player.sliding_collider.set_deferred("disabled", false)

func input(_event: InputEvent) -> int:
	super(_event) 
	
	# I think there are no inputs other than direction change, you just wait it out
	# you cannot jump from here btw
	return State.Null

func physics_process(_delta: float) -> int:
	super(_delta)
	# If we are done sliding, leave
	if _next_state != BaseState.State.Null:
		return _next_state
	
	if player.direction == 0:
		player.velocity.x = sliding_speed
	else:
		player.velocity.x = sliding_speed * player.direction
	
	player.move_and_slide()
	
	if !player.is_on_floor():
		return State.Jump
	
	return State.Null

# The timer lets us know how long till we stop sliding and go back to Idle
# We could reconsider doing this by distance instead of time (would make sense
# if fps drops were possible, but it is unlikley due to size. In short - this is
# just easier to code. That being said, I don't love having a timer tightly coupled here
# 
# Also, it's important to know that signals will be caught in a void code. Thus,
# We need to make the transition to another state in the next _physics_process 
# frame, so technically we'll always be one frame late. This is why counting distance
# could be more precise.
func _on_slide_timer_timeout() -> void:
	_next_state = BaseState.State.Idle
	
	# Return to the standing collider
	player.standing_collider.set_deferred("disabled", false)
	player.sliding_collider.set_deferred("disabled", true)
	
