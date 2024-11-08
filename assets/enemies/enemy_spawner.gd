extends Area2D

@export var enemy_scene: PackedScene
var enemy_instance

func _ready() -> void:
	pass

func spawn_enemy() -> void:
	if enemy_instance == null:
		enemy_instance = enemy_scene.instantiate()
		
		# Use this as I was getting an error "Can't change this state while flushing queries.
		# Need to read more about this
		call_deferred("add_child", enemy_instance)
		#add_child(enemy_instance)



func _on_area_exited(_area: Area2D) -> void:
	spawn_enemy()


func _on_area_entered(_area: Area2D) -> void:
	spawn_enemy()
