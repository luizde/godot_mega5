extends Node2D

@export var start_even_light: bool
@onready var color_switcher_over_time: ColorSwitcherOverTime = $ColorSwitcherOverTime


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if start_even_light:
		color_switcher_over_time.index_start = 1
	else:
		color_switcher_over_time.index_start = 0
	
	color_switcher_over_time.begin()
