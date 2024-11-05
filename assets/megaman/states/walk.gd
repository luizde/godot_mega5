extends BaseState

@export var walk_shoot_animation:String
@onready var lower_cannon: Timer = $LowerCannon
@onready var walk_shoot_muzzle: Node2D = $WalkShootMuzzle

func enter() -> void:
	super()
	
	#if Input.is_action_pressed("move_left"):
		#player.face_left()
	#elif Input.is_action_pressed("move_right"):
		#player.face_right()
	
	
func input(_event: InputEvent) -> int:
	super(_event)
	#if Input.is_action_pressed("move_left"):
		#player.face_left()
	#elif Input.is_action_pressed("move_right"):
		#player.face_right()
	
	if Input.is_action_pressed("move_down") and Input.is_action_just_pressed("jump"):
		GodotLogger.debug("Slide start")
		return State.Slide
	
	if Input.is_action_just_pressed("jump"):
		return State.Jump
	
	if !Input.is_action_pressed("move_left") and !Input.is_action_pressed("move_right"):
		return State.Idle
		
	if Input.is_action_just_pressed("shoot"):
		player.animations.play(walk_shoot_animation)
		player.shoot(walk_shoot_muzzle)
		lower_cannon.start()
	
	return State.Null
	
func physics_process(_delta: float) -> int:
	super(_delta)
	# We can also do with move and slide I guess? to keep consistencies
	# 	but I find it often does unwanted stuff like sliding too much 
	player.velocity.x = player.SPEED * player.direction
	player.move_and_slide()
	
	if !player.is_on_floor():
		return State.Jump
	#player.move_and_collide(Vector2(player.SPEED * player.direction * _delta, 0))
	
	return State.Null

func exit() -> void:
	# The timer that calls back the lower fire could be running. Stop it.
	lower_cannon.stop()

func _on_lower_cannon_timeout() -> void:
	player.animations.play(animation_name)
	
