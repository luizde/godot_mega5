extends Sprite2D


func _on_timer_blink_timeout() -> void:
	if visible:
		visible = false
	else:
		visible = true
