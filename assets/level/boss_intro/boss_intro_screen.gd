extends Node2D

## This should be loaded in the last scene.
## We are hardcoding Gravity Man's stage but this is easy to change to a parameter.
## We can even  create a utility function that does this. It is still kinda clunky
## Wish Godot implemented parameters for loading scenes
@export var next_scene: Resource

func start_next_scene() -> void:
	#doing this with a resource, but it may be better to use PackedScene 
	# and receive it in the previous scene
	
	var next_scene = load(next_scene.resource_path).instantiate();
	get_tree().get_root().add_child(next_scene)	
	get_tree().get_root().remove_child(self)
