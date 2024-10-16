extends Area2D

var direction: int = 1
var speed: float = 175.0
var damage: int = 2
var shooter_name: String

func _process(delta: float) -> void:
	position.x += speed * delta * direction
	

## Bullets have to disappear after while if they hit nothing.
## 
func _on_timer_disappear_timeout() -> void:
	queue_free()


func _on_body_entered(_body: Node2D) -> void:
	EventBus.enemy_hit_player.emit(shooter_name, damage)
	queue_free()
