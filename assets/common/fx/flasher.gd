extends Node2D

var sprites_flashing: AnimatedSprite2D
@onready var flash_material: Material = preload("res://assets/common/fx/flasher_material.tres")
@onready var flash_timer: Timer = $FlasherTimer

func start_flicker(flash_duration: float, sprites:AnimatedSprite2D, flash_intensity: float):
	
	sprites_flashing = sprites
		
	if sprites_flashing.material == null or sprites_flashing.material != flash_material:
		sprites_flashing.material = flash_material
	
	sprites_flashing.material.set_shader_parameter("flash_intensity", clampf(flash_intensity, 0.0, 1.0))
	
	flash_timer.wait_time = flash_duration
	flash_timer.start()


func _on_flasher_timer_timeout() -> void:
	sprites_flashing.material.set_shader_parameter("flash_intensity", 0.0)
