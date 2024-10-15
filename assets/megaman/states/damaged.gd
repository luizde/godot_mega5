extends BaseState

@onready var invul_timer: Timer = $InvulTimer

var _return_to_idle: bool = false

func enter() -> void:
	super()
	
	_return_to_idle = false
	player.velocity.y = 0
	player.is_vulnerable = false
	
	#TODO: there's some effect played. can we do it with particles?
	invul_timer.start()
	# move against players's direction for a bit, then give control back

func physics_process(delta: float) -> int:
	
	player.velocity.x = player.SPEED * player.direction * -1 / 8
	player.velocity.y += player.gravity
	
	player.move_and_slide()
	
	if _return_to_idle:
		return BaseState.State.Idle
		
	return BaseState.State.Null
	



func _on_invul_timer_timeout() -> void:
	_return_to_idle = true
	player.is_vulnerable = true
