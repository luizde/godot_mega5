extends Node2D

#@onready var screen_transition_animation: AnimationPlayer = $ScreenTransitionAnimation/AnimationPlayer
@onready var screen_transition_animation: AnimationPlayer = $LevelLayout/Room_01/ScreenTransitionAnimation/AnimationPlayer

func _ready() -> void:
	
	GodotLogger.debug("Starting level")
	#Ensure the transition doesn't glitch out.
	screen_transition_animation.get_parent().get_node("ColorRect").color.a = 255 
	screen_transition_animation.play_backwards("fade_in")
	EventBus.player_died.connect(_fade_out)

func _fade_out() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_interval(1)
	tween.tween_callback(screen_transition_animation.play.bind("fade_in"))
	
	await get_tree().create_timer(3.0).timeout
	_restart_level()

func _restart_level() -> void:
	if get_tree():
		get_tree().reload_current_scene()
