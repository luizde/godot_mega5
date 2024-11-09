extends Node

@onready var gravity_downwards: bool = true

@export var enemy: BaseEnemy

func _ready() -> void:
	EventBus.gravity_changed.connect(handle_gravity_change)
	
func handle_gravity_change(downwards: bool) -> void:
	if downwards:
		enemy.animated_sprite_2d.flip_v = false
		enemy.up_direction = Vector2(0, -1)
		enemy.collider_physics.position = enemy.collider_position_gravity_down
	else:
		enemy.animated_sprite_2d.flip_v = true
		enemy.up_direction = Vector2(0, 1)
		enemy.collider_physics.position = enemy.collider_position_gravity_up
