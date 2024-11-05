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
	Teleport
}

#@export var material_charging:Material = preload("res://assets/megaman/shaders/charge_material.tres")

@export var animation_name: String
@export var animation_shooting_name: String

var player: Player
var bullet = preload("res://assets/megaman/weapons/megaman_bullet.tscn")

func _ready() -> void:
	EventBus.player_enters_room.connect(reset_y_velocity)
	

func enter() -> void:
	player.animations.play(animation_name)

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
		player.charge_time = clamp(player.charge_time + _delta, 0, 2)
	else:
		player.charging_colorer.stop_flicker()
		player.charge_time = 0.0
	
	if player.charge_time >= 1.0 and player.charge_time < 2.0:
		player.charging_colorer.start_flicker(player, 0.1, player.animations)
	elif player.charge_time >= 2.0:
		player.charging_colorer.start_flicker(player, 0.05, player.animations)
	
	return State.Null
	
#func shoot(muzzle:Node2D) -> void:
	## Instantiate a bullet
	#var new_bullet = bullet.instantiate()
#
	#var new_position = Vector2((muzzle.global_position.x * player.direction) + player.position.x, 
			#+ muzzle.global_position.y + player.position.y)
	#new_bullet.set_position(new_position)
	#
	#if player.direction == -1:
		#new_bullet.scale.y *= -1  #TODO
		#new_bullet.direction = player.direction
		#
	#$".".add_child(new_bullet)
	
func reset_y_velocity(_na, _none) -> void:
	player.velocity.y = 0
