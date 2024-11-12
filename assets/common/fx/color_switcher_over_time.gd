extends Node
class_name ColorSwitcherOverTime

@export var colors: PackedColorArray 
@export var index_start: int
@export var time_to_change: float
@export var sprites: Sprite2D
@export var animated_sprites: AnimatedSprite2D
@onready var timer: Timer = $Timer

var current_color: Color

var _current_index: int

func begin() -> void:
	timer.wait_time = time_to_change
	timer.timeout.connect(change_next_color)
	timer.start()
	_current_index = index_start
	
	
	

func change_next_color() -> void:
	if _current_index >= colors.size():
		_current_index = _current_index % 2
	
	if sprites != null:
		sprites.material.set_shader_parameter("flash_color", colors[_current_index])
		
	if animated_sprites != null:
		animated_sprites.material.set_shader_parameter("flash_color", colors[_current_index])
	#GodotLogger.debug("Setting color %s" % colors[_current_index])
	_current_index += 1
	
