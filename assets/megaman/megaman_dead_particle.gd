extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var speed: float = 300.0

func _process(delta: float) -> void:
	#position.x += speed * delta
	translate(transform.x.normalized() * speed * delta)
