extends BaseState

@onready var invul_timer: Timer = $InvulTimer
@onready var damaged_timer: Timer = $DamagedParticles/Timer
@onready var damaged_particles: Sprite2D = $DamagedParticles
@onready var disable_move_timer: Timer = $DisableMoveTimer

var _return_to_idle: bool = false

func enter() -> void:
	super()
	
	_return_to_idle = false
	player.velocity.y = 0
	player.is_vulnerable = false
	
	# activate FX
	var fx_flip_h: bool = true if player.direction == 1 else false
	player.damaged_smoke_emmitter.emit_fx(player.position, true, fx_flip_h, false)
	
	invul_timer.start()
	disable_move_timer.start()
	damaged_timer.start()
	damaged_particles.visible = false
	# move against players's direction for a bit, then give control back

func input(_event: InputEvent) -> int:
	#we can't move in this state. p
	return State.Null

func physics_process(_delta: float) -> int:
	
	if _return_to_idle:
		return BaseState.State.Idle
		
	player.velocity.x = player.speed * player.direction * -1 / 8
	player.velocity.y += WorldPhysics.gravity
	
	player.move_and_slide()
	
	return BaseState.State.Null

func exit() -> void:
	damaged_timer.stop()
	damaged_particles.visible = false
	
	# We need the lines below because sometimes when exitting the next _phyisics 
	# cycle will run in the Idle state and then when going to walk it will step
	# in the wrong direction.
	# This could also be solved by going directly to walk instead of Idle when
	# buttons are pressed
	if Input.is_action_pressed("move_left"):
		player.face_left()
	elif Input.is_action_pressed("move_right"):
		player.face_right()

func _on_invul_timer_timeout() -> void:
	player.is_vulnerable = true


func _on_disable_move_timer_timeout() -> void:
	_return_to_idle = true
	player.velocity.x = 0
