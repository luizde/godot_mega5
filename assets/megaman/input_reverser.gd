#extends Node
#
#var swap_mode: bool = false
#
#func _ready() -> void:
	#EventBus.gravity_changed.connect(reverse_up_input)
	#
#func reverse_up_input(downwards: bool):
	#if downwards:
		#var new_input = InputEventKey.new()
		#
		#InputMap.act
