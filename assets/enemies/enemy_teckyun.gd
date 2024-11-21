extends BaseEnemy

@onready var animation_player: AnimationPlayer = $Head/AnimationPlayer
@onready var timer: Timer = $Timer

var _direction_reverse: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.timeout.connect(play_anim)
	timer.start()


func play_anim() -> void:
	if _direction_reverse:
		animation_player.play_backwards("enemy_teckyun/rotate_right")
	else:
		animation_player.play("enemy_teckyun/rotate_right")
	_direction_reverse = !_direction_reverse


func _on_damage_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		send_damage()
