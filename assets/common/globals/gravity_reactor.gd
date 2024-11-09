extends Node

@onready var gravity_downwards: bool = true

var player: Player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	EventBus.gravity_changed.connect(handle_gravity_change)
	
func handle_gravity_change(downwards: bool) -> void:
	if downwards:
		player.animations.flip_v = false
		player.up_direction = Vector2(0, -1)
		player.jump_force = abs(player.jump_force) * -1
	else:
		player.animations.flip_v = true
		player.up_direction = Vector2(0, 1)
		player.jump_force = abs(player.jump_force)
