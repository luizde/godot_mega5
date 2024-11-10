extends Area2D
class_name Ladder

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var position_to_send: Vector2 = Vector2(global_position.x +7, body.global_position.y)
		#We need to change 'y' a bit cause it is not until next frame that it will shift state
		#therefore, we need to add the current velocity multiplied by the next delta
		EventBus.player_enters_ladder.emit(position_to_send, body.velocity.y)


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		EventBus.player_leaves_ladder.emit()
