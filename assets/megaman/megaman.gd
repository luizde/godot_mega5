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

#region Movement and speed
# Original game was 1.375 px per frame. We are locking at 60 fps, therefore
#	1.375 * 60 = 82.5 px per sec
@export var speed: float = 82.5 
@export var jump_force: float = -300.0
@export var speed_slide: float = 150.0
var is_on_ladder:bool = false:
	get:
		return is_on_ladder
var ladder_velocity_before_touch: float

var ladder_touched_position: Vector2
#endregion

#region Necessary colliders
@onready var standing_collider: CollisionShape2D = $StandingCollider
@onready var ray_cast_feet: RayCast2D = $RayCastFeet
@onready var ray_cast_head: RayCast2D = $RayCastHead
#endregion

#region shooting variables

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


func _ready() -> void:
	velocity = Vector2.ZERO
	states.init(self)
	
	hp_current = hp_max
	
	EventBus.enemy_hit_player.connect(receive_damage)
	EventBus.player_enter_spikes.connect(instadie)
	
	EventBus.player_enters_room.connect(_handle_room_enter)
	EventBus.player_enters_ladder.connect(_handle_enter_ladder)
	EventBus.player_leaves_ladder.connect(_handle_leave_ladder)
	
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

func shoot(muzzle_position: Vector2) -> void:
	if direction == -1:
		muzzle_position.x *= -1
	shooter.shoot_bullet(self, muzzle_position, direction, charge_level)
	charge_time = 0.0

func _handle_room_enter(_none, _none2, _room_rect: Rect2) -> void:
	disable_movement()
	await get_tree().create_timer(1.20).timeout
	enable_movement()

func _handle_enter_ladder(ladder_position: Vector2, velocity_y:float) -> void:
	GodotLogger.debug("Player is touching ladder")
	ladder_touched_position = ladder_position
	ladder_velocity_before_touch = velocity_y
	is_on_ladder = true
	
func _handle_leave_ladder() -> void:
	GodotLogger.debug("Player is leaving ladder")
	is_on_ladder = false
