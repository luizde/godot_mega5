class_name Player
extends CharacterBody2D

@export var gravity = 15.0
@export var falling_gravity = 15.0

@export var hp_max:int = 28
@export var hp_current: int :
	get:
		return hp_current

# Where the character is facing. Usually he'll be facing to the right at the beginning
var direction: int = 1

# Is he in motion or not? Used as an auxiliary variable
var is_moving_horizontal: int = 0 # Keep as number instead of boolean and we can just multiply

@onready var animations: AnimatedSprite2D = $AnimatedSprite2D
@onready var states = $StateManager

# references to the colliders
@onready var standing_collider: CollisionShape2D = $StandingCollider
@onready var sliding_collider: CollisionShape2D = $SlidingCollider

# reference to idle animation shoot muzzle
@onready var idle_shoot_muzzle: Node2D = $StateManager/Idle/IdleShootMuzzle
var _shoot_muzzle_position:Vector2

var is_vulnerable: bool :
	get:
		return is_vulnerable
	set(value):
		is_vulnerable = value

# Original game was 1.375 px per frame. We are locking at 60 fps, therefore
#	1.375 * 60 = 82.5 px per sec
@export var SPEED = 82.5 

func _ready() -> void:
	velocity = Vector2.ZERO
	states.init(self)
	_shoot_muzzle_position = idle_shoot_muzzle.position
	
	hp_current = hp_max
	
	EventBus.enemy_hit_player.connect(receive_damage)
	
	is_vulnerable = true
	
func _unhandled_input(event: InputEvent) -> void:
	states.input(event)
	

func _physics_process(delta: float) -> void:
	states.physics_process(delta)

## Group all player activities required to face the right side of the screen
## TODO: review / should this be in base_state?
func face_right() -> void:
	direction = 1
	animations.flip_h = true	
	

## Group all player activities required to face the left side of the screen
## 
func face_left() -> void:
	direction = -1
	animations.flip_h = false	
	

func receive_damage(_enemy_name: String, damage_hp: int) -> void:
	
	if is_vulnerable:
		hp_current -= damage_hp
		
		if(hp_current <= 0):
			states.change_state(BaseState.State.Dead)
		else:
			states.change_state(BaseState.State.Damaged)
