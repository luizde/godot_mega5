extends BaseState

func enter() -> void:
	player.animations.play(animation_name)
	player.animations.pause()
	player.disable_movement()
	

func input(_event: InputEvent) -> int:
	return State.Null

func physics_process(_delta) -> int:
	
	player.velocity.y += WorldPhysics.gravity * 2
	
	player.move_and_slide()
	
	if player.is_on_floor():
		player.animations.play()
		player.enable_movement()
		EventBus.player_teleported_into_level.emit()
		return State.Idle
	
	return State.Null
