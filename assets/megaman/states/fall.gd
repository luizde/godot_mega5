extends BaseState

func enter() -> void:
	super()
	

func physics_process(_delta: float) -> int:
	
	# We cap velocity at 420 px per sec or 7px per frame
	if player.velocity.y >= player.gravity * 60:
		player.velocity.y = player.gravity * 60
	else:
		player.velocity.y += player.gravity
	
	player.velocity.x = player.direction * player.is_moving_horizontal * player.SPEED 
		
	#player.move_and_collide(Vector2(
	#			move * player.SPEED * _delta,
	#			player.gravity * _delta
	#))
	#TODO: maybe reconsider and use move_and_collide. The downside is we need to create
	# 		our own is_on_floor, but we get more control and physics are easily defined here
	player.move_and_slide()
	
	if player.is_on_floor():
		return State.Idle
	
	if player.velocity.y > 0:
		return State.Fall
	
	return State.Null
