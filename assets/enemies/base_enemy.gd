class_name BaseEnemy
extends CharacterBody2D

@export var enemy_name: String

@export var invulnerable: bool = false
@export var is_static: bool = false
@export var hp: int
@export var damage_shot: int
@export var damage_touch: int

@export var death_animation_name: String 
@export var animated_sprite_2d: AnimatedSprite2D
#@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var collider_physics: CollisionShape2D

#Wish I could force all enemies had this. I have to remember
@export var flasher: Flasher

var player: Player
var player_direction:int #relative to enemy. -1 left, anything else right

@export var muzzle_position_x: float = 100000.0
@export var muzzle_position_y: float = 100000.0

@export var reacts_to_gravity:bool = true

#region
@export var collider_position_gravity_down: Vector2
@export var collider_position_gravity_up: Vector2
#endregion

func _ready() -> void:
	EventBus.player_hit_enemy_normalshot.connect(take_damage)
	
	#grab a reference to the player
	player = get_tree().get_nodes_in_group("player")[0]
	

func _process(_delta) -> void:
	look_at_player()
	

func _physics_process(_delta) -> void:
	if reacts_to_gravity:
		velocity.y += WorldPhysics.gravity
		move_and_slide()

func _on_body_entered(_body: Node2D) -> void:
	EventBus.enemy_hit_player.emit(enemy_name, damage_touch)

func send_damage() -> void:
	EventBus.enemy_hit_player.emit(enemy_name, damage_touch)

func take_damage(damage: int, enemy_id) -> void:
	if get_instance_id() == enemy_id and !invulnerable:
		flasher.start_flash(0.2, animated_sprite_2d, 0.4)
		
		hp -= damage
		
		GodotLogger.debug("Enemy [%s] received [%d] damage. New HP is %d" % [enemy_name, damage, hp])
		
		if hp <= 0:
			animated_sprite_2d.play(death_animation_name)
			if !animated_sprite_2d.animation_looped.is_connected(on_death_timer_timeout):
				animated_sprite_2d.animation_looped.connect(on_death_timer_timeout)
			
			# We remove the Colliders right away so player can't collide with the explosion
			#MiscUtils.setDisabledForChildrenCollisionShapes(get_node("."), true, true)
			reacts_to_gravity = false
			MiscUtils.set_disabled_children_area2d(self, true, true)
			MiscUtils.setDisabledForChildrenCollisionShapes(self, true, true)
			#monitoring = false
	

func on_death_timer_timeout() -> void:
	queue_free()

func look_at_player(flip_sprite: bool = true) -> void:
	if !is_static:
		if player == null:
			player = get_tree().get_nodes_in_group("player")[0]
		#assume our objects are always facing left. all our sprites are set up in such way
		if player.global_position.x < self.global_position.x:
			if flip_sprite:
				animated_sprite_2d.flip_h = false
			player_direction = -1
		else:
			if flip_sprite:
				animated_sprite_2d.flip_h = true
			player_direction = 1
