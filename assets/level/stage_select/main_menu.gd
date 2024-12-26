extends Node2D

@export var selected_level:MainMenuOption
@onready var blinking_square: Node2D = $BlinkingSquare
@onready var change_selection: AudioStreamPlayer = $ChangeSelection
@onready var audio_selected: AudioStreamPlayer = $AudioSelected

@export var next_screen: PackedScene

@onready var screen_transition_animation: AnimationPlayer = $ScreenTransitionAnimation/AnimationPlayer

func _ready() -> void:
	screen_transition_animation.play_backwards("fade_in")

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
	
	GodotLogger.debug("Current level selection is [%s]" % selected_level.stage_name)
	
	if _event.is_action_pressed("shoot") and \
			selected_level.enabled and !selected_level.stage_name == "Mega Man":
		audio_selected.play()
		_start_level_transition()
		
## Load the next level. It is hard coded now but we would have a Dictionary where
## you can look up scenes by name from the MainMenuOption
func _start_level_transition() -> void:
	var tween: Tween = get_tree().create_tween()
	screen_transition_animation.play("fade_in")
	tween.tween_interval(2)
	tween.tween_callback(_load_level)
	
	
func _load_level() -> void:
	get_tree().change_scene_to_packed(selected_level.stage_scene)
