extends Node2D
class_name Flasher

var sprites_flashing: AnimatedSprite2D
@onready var flash_material: Material = preload("res://assets/common/fx/flasher_material.tres")
@onready var flash_timer: Timer = $FlasherTimer
@onready var flicker_toggle_timer: Timer = $FlickerToggleTimer

var _flash_intensity: float

var _flicker_toggle: bool = true

func start_flash(flash_duration: float, sprites:AnimatedSprite2D, flash_intensity: float):
	
	sprites_flashing = sprites
		
	if sprites_flashing.material == null or sprites_flashing.material != flash_material:
		sprites_flashing.material = flash_material.duplicate()
	
	_flash_intensity = flash_intensity
	sprites_flashing.material.set_shader_parameter("flash_intensity", clampf(_flash_intensity, 0.0, 1.0))
	
	flash_timer.wait_time = flash_duration
	flash_timer.start()

func start_flicker(flicker_duration: float, flicker_toggle_duration: float, sprites:AnimatedSprite2D, flash_intensity: float):
	sprites_flashing = sprites
	
	if sprites_flashing.material == null or sprites_flashing.material != flash_material:
		sprites_flashing.material = flash_material.duplicate()
		
	_flash_intensity = flash_intensity
	sprites_flashing.material.set_shader_parameter("flash_intensity", clampf(_flash_intensity, 0.0, 1.0))
	
	flash_timer.wait_time = flicker_duration
	flash_timer.start()
	
	flicker_toggle_timer.wait_time = flicker_toggle_duration
	flicker_toggle_timer.start()


func _on_flasher_timer_timeout() -> void:
	sprites_flashing.material.set_shader_parameter("flash_intensity", 0.0)
	flicker_toggle_timer.stop()


func _on_flicker_toggle_timer_timeout() -> void:
	if _flicker_toggle:
		sprites_flashing.material.set_shader_parameter("flash_intensity", _flash_intensity)
	else:
		sprites_flashing.material.set_shader_parameter("flash_intensity", 0.0)
		
	_flicker_toggle = !_flicker_toggle
