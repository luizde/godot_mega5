class_name BaseState
extends Node

#This enum is so that every state can reference each other for its return val
enum State {
	Null,
	Idle,
	Step,
	Walk,
	Slide,
	Jump,
	Fall,
	Damaged,
	Dead,
	Teleport,
	Ladder
}

@export var animation_name: String
@export var animation_shooting_name: String

@export var muzzle_position_relative_x: float = 10000.0
@export var muzzle_position_relative_y: float = 10000.0

var player: Player
var bullet = preload("res://assets/megaman/weapons/megaman_bullet.tscn")

func _ready() -> void:
	EventBus.player_enters_room.connect(reset_y_velocity)
	
	

func enter() -> void:
	player.animations.play(animation_name)
	if Input.is_action_pressed("move_left"):
		player.face_left()
	elif Input.is_action_pressed("move_right"):
		player.face_right()

## Will execute before leaving the State and starting the new state
func exit() -> void:
	pass #this should be extended if necessary
	 

# We return an enum, which is really an int behind the scenes
func input(_event: InputEvent) -> int:
	
	if !player.is_movement_enabled:
		return State.Null
	
	if Input.is_action_pressed("move_left"):
		player.face_left()
		player.is_moving_horizontal = 1
	elif Input.is_action_pressed("move_right"):
		player.face_right()
		player.is_moving_horizontal = 1
	elif !Input.is_action_pressed("move_left") and !Input.is_action_pressed("move_right"):
		player.is_moving_horizontal = 0
	
	if player.ray_cast_head.is_colliding() and Input.is_action_pressed("move_up"):
		GodotLogger.debug("going into ladder")
		player.position.y -= 16
		return State.Ladder
		
	if Input.is_action_pressed("shoot"):
		player.charging = true
	
	if Input.is_action_just_released("shoot"):
		#player.charge_time = 0
		player.charging = false
	
	return State.Null
	
func process(_delta: float) -> int:
	return State.Null

func physics_process(_delta: float) -> int:
	player.velocity.y += WorldPhysics.gravity
	
	if player.charging:
		
		if !player.audio_player.playing and player.charge_time > 0.5:
			player.audio_player.play()
		player.charge_time = clamp(player.charge_time + _delta, 0, 2)
	else:
		player.charging_colorer.stop_flicker()
		player.charge_time = 0.0
	
	if player.charge_time >= 1.0 and player.charge_time < 2.0:
		player.charging_colorer.start_flash(player, 0.1, player.animations)
	elif player.charge_time >= 2.0:
		player.charging_colorer.start_flash(player, 0.05, player.animations)
	
	return State.Null
	
	
func reset_y_velocity(_na, _none, _room_rect: Rect2) -> void:
	player.velocity.y = 0
