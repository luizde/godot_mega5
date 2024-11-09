extends Node

@export var fx: PackedScene
@export var fx_duration: float
@onready var fx_duration_timer: Timer = $FxDurationTimer

var _new_fx:Node

## Will emmit the FX assigned in the inspector
## 
func emit_fx(position: Vector2, move_with_parent: bool = true, flip_h: bool = false, flip_v: bool = false):
	_new_fx = fx.instantiate()
		
	if flip_h:
		_new_fx.scale.x *= -1
		
	if flip_v:
		_new_fx.scale.y *= -1
	
	if !move_with_parent:
		_new_fx.top_level = true
		_new_fx.set_position(position)
	
	add_child(_new_fx)
	
	fx_duration_timer.start()


func _on_fx_duration_timer_timeout() -> void:
	_new_fx.queue_free()
	
