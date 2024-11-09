class_name BaseEnemy
extends Area2D

var enemy_name: String

@export var hp: int
var damage_shot: int
var damage_touch: int

@export var death_animation_name: String 
#var animations: AnimatedSprite2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

#Wish I could force all enemies had this. I have to remember
@onready var flasher = $Flasher 

var player: Player
var player_direction:int #relative to enemy. -1 left, anything else right

@export var muzzle_position_x: float = 100000.0
@export var muzzle_position_y: float = 100000.0

func _ready() -> void:
	EventBus.player_hit_enemy_normalshot.connect(take_damage)
	
	#grab a reference to the player
	player = get_tree().get_nodes_in_group("player")[0]
	

func _process(_delta) -> void:
	look_at_player()
	

func _on_body_entered(_body: Node2D) -> void:
	EventBus.enemy_hit_player.emit(enemy_name, damage_touch)

func take_damage(damage: int) -> void:
	flasher.start_flash(0.2, animated_sprite_2d, 0.4)
	
	hp -= damage
	
	GodotLogger.debug("Enemy [%s] received [%d] damage. New HP is %d" % [enemy_name, damage, hp])

	
	if hp <= 0:
		animated_sprite_2d.play(death_animation_name)
		animated_sprite_2d.animation_looped.connect(on_death_timer_timeout)
		
		# We remove the Colliders right away so player can't collide with the explosion
		MiscUtils.setDisabledForChildrenCollisionShapes(get_node("."), true, true)
		monitoring = false
	

func on_death_timer_timeout() -> void:
	queue_free()

func look_at_player() -> void:
	#assume our objects are always facing left. all our sprites are set up in such way
	if player.global_position.x < self.global_position.x:
		animated_sprite_2d.flip_h = false
		player_direction = -1
	else:
		animated_sprite_2d.flip_h = true
		player_direction = 1
