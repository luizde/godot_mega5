extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		EventBus.player_enter_spikes.emit("pit")
