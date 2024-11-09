extends Area2D

@export var gravity_downwards: bool

func _on_body_entered(body: Node2D) -> void:
	GodotLogger.debug("Gravity changed. Inversed=[%s]" % gravity_downwards)
	EventBus.gravity_changed.emit(gravity_downwards)
