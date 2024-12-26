extends Node2D

@export var selected_level:MainMenuOption
@onready var blinking_square: Node2D = $BlinkingSquare
@onready var change_selection: AudioStreamPlayer = $ChangeSelection

@export var next_screen: PackedScene

func _unhandled_input(_event: InputEvent) -> void:
	
	if _event.is_action_pressed("move_right") and selected_level.right != null:
			selected_level = selected_level.right
			blinking_square.position = selected_level.position
			change_selection.play()
			
	if _event.is_action_pressed("move_left") and selected_level.left != null:
			selected_level = selected_level.left
			blinking_square.position = selected_level.position
			change_selection.play()
			
	if _event.is_action_pressed("move_up") and selected_level.up != null:
			selected_level = selected_level.up
			blinking_square.position = selected_level.position
			change_selection.play()
			
	if _event.is_action_pressed("move_down") and selected_level.down != null:
			selected_level = selected_level.down
			blinking_square.position = selected_level.position
			change_selection.play()
	
	GodotLogger.debug("Current selection is [%s]" % selected_level.stage_name)
	
	if _event.is_action_pressed("shoot") and selected_level.stage_name == "Mega Man":
		get_tree().change_scene_to_packed(next_screen)
