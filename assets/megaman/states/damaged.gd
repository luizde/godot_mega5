extends BaseState

@onready var invul_timer: Timer = $InvulTimer
@onready var damaged_timer: Timer = $DamagedParticles/Timer
@onready var damaged_particles: Sprite2D = $DamagedParticles

var _return_to_idle: bool = false

func enter() -> void:
	super()
	
	_return_to_idle = false
	player.velocity.y = 0
	player.is_vulnerable = false
	
	invul_timer.start()
	damaged_timer.start()
	damaged_particles.visible = false
	# move against players's direction for a bit, then give control back

func input(_event: InputEvent) -> int:
	#we can't move in this state. p
	return State.Null

func physics_process(_delta: float) -> int:
	
	player.velocity.x = player.speed * player.direction * -1 / 8
	player.velocity.y += WorldPhysics.gravity
	
	player.move_and_slide()
	
	if _return_to_idle:
		return BaseState.State.Idle
		
	return BaseState.State.Null

func exit() -> void:
	damaged_timer.stop()
	damaged_particles.visible = false

func _on_invul_timer_timeout() -> void:
	_return_to_idle = true
	player.is_vulnerable = true
