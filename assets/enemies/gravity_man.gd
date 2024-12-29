extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func animation_play_intro() -> void:
	GodotLogger.debug("Playing boss intro animation")
	animated_sprite_2d.play("intro_pose")

func animation_play_tornado() -> void:
	GodotLogger.debug("Playing boss intro tornado")
	animated_sprite_2d.play("tornado")
