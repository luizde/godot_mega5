extends AudioStreamPlayer

func _ready() -> void:
	EventBus.player_died.connect(_handle_player_death)
	
	
func _handle_player_death() -> void:
	var fadeout: Tween = create_tween()
	
	fadeout.tween_property(self, "volume_db", -40, 3.0)
