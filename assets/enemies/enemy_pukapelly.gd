extends BaseEnemy

@onready var timer_moving: Timer = $TimerMoving
@onready var timer_stopped: Timer = $TimerStopped

@export var speed: float = 60.0

var _moving:bool = false
var _move_towards: Vector2
var _is_active:bool = false

func _ready() -> void:
	super()
	timer_stopped.start()
	animated_sprite_2d.play("closed")


func _physics_process(_delta:float) -> void:
	if _moving and _is_active:
		#GodotLogger.debug("Pukapelly Moving towards " % _move_towards)
		position = position.move_toward(_move_towards, speed * _delta)
		#position.lerp(player.position, 0.012)
		
		
		


func _on_timer_stopped_timeout() -> void:
	if hp > 0:
		_moving = true
		timer_moving.start()
		_move_towards = player.position
		animated_sprite_2d.play("open")


func _on_timer_moving_timeout() -> void:
	if hp > 0:
		_moving = false
		timer_stopped.start()
		animated_sprite_2d.play("closed")


func _on_detection_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		_is_active = true


func _on_detection_range_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		_is_active = false
