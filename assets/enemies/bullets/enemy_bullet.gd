extends Area2D

var direction: int = 1
var speed: float = 175.0
var damage: int = 2
var shooter_name: String

func _process(delta: float) -> void:
	position.x += speed * delta * direction
	


func _on_body_entered(_body: Node2D) -> void:
	if _body.is_in_group("player"):
		EventBus.enemy_hit_player.emit(shooter_name, damage)
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
