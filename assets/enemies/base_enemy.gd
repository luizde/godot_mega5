class_name BaseEnemy
extends Node

var enemy_name: String

var hp: int
var damage_shot: int
var damage_touch: int

var death_animation_name: String 

func _ready() -> void:
	EventBus.player_hit_enemy_normalshot.connect(take_damage)

func _on_body_entered(body: Node2D) -> void:
	EventBus.enemy_hit_player.emit(enemy_name, damage_touch)

func take_damage(damage: int) -> void:
	hp -= damage
	if hp <= 0:
		#TODO: add death fx
		queue_free()
