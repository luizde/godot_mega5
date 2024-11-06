class_name Player
extends CharacterBody2D

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

#region shooting variables
# reference to idle animation shoot muzzle
@onready var idle_shoot_muzzle: Node2D = $StateManager/Idle/IdleShootMuzzle
var _shoot_muzzle_position:Vector2

@onready var charging_colorer = $ChargingColorer :
	get:
		return charging_colorer

@onready var charge_time:float = 0

@onready var charge_level: BaseBullet.BULLET_TYPE:
	get:
		if charge_time < 1.0:
			return BaseBullet.BULLET_TYPE.NORMAL
		elif charge_time < 2.0:
			return BaseBullet.BULLET_TYPE.MEDIUM
		else:
			return BaseBullet.BULLET_TYPE.CHARGED
		
@onready var charging: bool = false

@onready var shooter = $Shooter
#endregion 

#region Graphic FX
@onready var slide_smoke_emmitter: Node = $SlideSmokeEmmitter
@onready var damaged_smoke_emmitter: Node = $DamagedSmokeEmmitter
#endregion

var is_vulnerable: bool :
	get:
		return is_vulnerable
	set(value):
		is_vulnerable = value

var is_movement_enabled: bool:
	get:
		return is_movement_enabled

# object for FX flash when hit by enemy
@onready var flasher: Node2D = $Flasher

# Original game was 1.375 px per frame. We are locking at 60 fps, therefore
#	1.375 * 60 = 82.5 px per sec
@export var speed = 82.5 

func _ready() -> void:
	velocity = Vector2.ZERO
	states.init(self)
	_shoot_muzzle_position = idle_shoot_muzzle.position
	
	hp_current = hp_max
	
	EventBus.enemy_hit_player.connect(receive_damage)
	EventBus.player_enter_spikes.connect(instadie)
	
	EventBus.player_enters_room.connect(handle_room_enter)
	
	is_vulnerable = true
	is_movement_enabled = true
	
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

## TODO: move to a hurtbox script outside of player properties object
func receive_damage(_enemy_name: String, damage_hp: int) -> void:
	
	if is_vulnerable:
		flasher.start_flicker(1.0, 0.1, animations, 0.4)
		hp_current = clamp(hp_current - damage_hp, 0, hp_max)
		
		EventBus.player_hp_changed.emit(hp_current)
		
		if(hp_current <= 0):
			states.change_state(BaseState.State.Dead)
		else:
			states.change_state(BaseState.State.Damaged)

func instadie(killer_entity: String) -> void:
	receive_damage(killer_entity, 1000)

func heal(_item_name: String, heal_hp: int) -> void:
	
	hp_current = clamp(hp_current + heal_hp, 0 , hp_max)
	
	EventBus.player_hp_changed.emit(hp_current)

func disable_movement() -> void:
	is_movement_enabled = false
	
func enable_movement() -> void:
	is_movement_enabled = true

func shoot(muzzle: Node2D) -> void:
	#
	shooter.shoot_bullet(self, muzzle, direction, charge_level)
	charge_time = 0.0

func handle_room_enter(_none, _none2) -> void:
	disable_movement()
	await get_tree().create_timer(1.20).timeout
	enable_movement()
	
