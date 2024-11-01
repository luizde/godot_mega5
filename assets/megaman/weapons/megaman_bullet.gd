extends Area2D

## Emitted when megaman's bullet hit something
##
signal megaman_bullet_hit

@export var damage:int = 1
@export var speed:float = 290.0
@export var direction: int = 1

func _process(delta: float) -> void:
	position.x += speed * delta * direction


func _on_disappear_timer_timeout() -> void:
	queue_free()



func _on_body_entered(_body: Node2D) -> void:
	EventBus.player_hit_enemy_normalshot.emit(1)
	#emit_signal("megaman_bullet_hit", "damage", 1)
	queue_free()


func _on_area_entered(_area: Area2D) -> void:
	EventBus.player_hit_enemy_normalshot.emit(1)
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
