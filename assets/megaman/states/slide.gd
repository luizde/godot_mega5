extends BaseState

@onready var slide_timer: Timer = $SlideTimer

var _next_state: int = BaseState.State.Null

const _STANDING_COLLIDER_SIZE_X = 12.0
const _STANDING_COLLIDER_SIZE_Y = 22.0

const _SLIDING_COLLIDER_SIZE_X = 27.5
const _SLIDING_COLLIDER_SIZE_Y = 22.0

func enter() -> void:
	super()
	
	slide_timer.start()
	_next_state = BaseState.State.Null
	
	# activate FX
	var fx_flip_h: bool = true if player.direction == 1 else false
	var slide_smoke_position: Vector2 = Vector2(player.position.x, player.position.y-5)
	player.slide_smoke_emmitter.emit_fx(slide_smoke_position, false, fx_flip_h, false)
	
	change_collider_to_slide()

func exit() -> void:
	change_collider_to_stand()

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
		player.velocity.x = player.speed_slide
	else:
		player.velocity.x = player.speed_slide * player.direction
	
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
	
func change_collider_to_slide() -> void:
	player.standing_collider.shape.size = Vector2(_SLIDING_COLLIDER_SIZE_X, _SLIDING_COLLIDER_SIZE_Y)

func change_collider_to_stand() -> void:
	player.standing_collider.shape.size = Vector2(_STANDING_COLLIDER_SIZE_X, _STANDING_COLLIDER_SIZE_Y)
