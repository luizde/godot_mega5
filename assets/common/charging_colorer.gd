extends Node
#class_name ChargingColorer

@onready var timer_flicker: Timer = $TimerFlicker
@export var charging_material: ShaderMaterial

var charging_object: Node2D
var charging_sprites:AnimatedSprite2D

@onready var is_flickering: bool = false
@onready var _onoff: float = 0.0

func start_flicker(object:Node2D, flicker_frequency_secs: float, animation_sprites:AnimatedSprite2D):
	charging_object = object
	timer_flicker.wait_time = flicker_frequency_secs
	charging_sprites = animation_sprites
	if !is_flickering:
		timer_flicker.start()
		_onoff = 1.0
		is_flickering = true


func _on_timer_flicker_timeout() -> void:
	
	
	if charging_sprites.material == null or charging_sprites.material != charging_material:
		charging_sprites.material = charging_material
		
	if _onoff == 1.0:
		_onoff = 0.0
	else:
		_onoff = 1.0
	charging_material.set_shader_parameter("onoff", _onoff)
	
	#else:
		#charging_sprites.material = null

func stop_flicker():
	timer_flicker.stop()
	
	if charging_sprites != null and charging_sprites.material != null:
		charging_material.set_shader_parameter("onoff", 0.0)
		#charging_sprites.material = null
	is_flickering = false
