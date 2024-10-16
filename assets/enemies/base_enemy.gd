class_name BaseEnemy
extends Node

var enemy_name: String

var hp: int
var damage_shot: int
var damage_touch: int

@export var death_animation_name: String 
var animations: AnimatedSprite2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	EventBus.player_hit_enemy_normalshot.connect(take_damage)
	animations = $AnimatedSprite2D
	

func _on_body_entered(_body: Node2D) -> void:
	EventBus.enemy_hit_player.emit(enemy_name, damage_touch)

func take_damage(damage: int) -> void:
	hp -= damage
	print(animated_sprite_2d.is_playing())
	if hp <= 0:
		animated_sprite_2d.play(death_animation_name)
		animated_sprite_2d.animation_looped.connect(on_death_timer_timeout)
		
		# We remove the Colliders right away so player can't collide with the explosion
		MiscUtils.setDisabledForChildrenCollisionShapes(get_node("."), true, true)
		
	

func on_death_timer_timeout() -> void:
	queue_free()
