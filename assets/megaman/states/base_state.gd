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
}

@export var animation_name: String


var player: Player
var bullet = preload("res://assets/megaman/megaman_bullet.tscn")

func enter() -> void:
	player.animations.play(animation_name)  

	
func exit() -> void:
	pass #this should be extended if necessary I believe - Luis
	
# We return an enum, which is really an int behind the scenes
func input(_event: InputEvent) -> int:
	
	if Input.is_action_pressed("move_left"):
		player.face_left()
		player.is_moving_horizontal = 1
	elif Input.is_action_pressed("move_right"):
		player.face_right()
		player.is_moving_horizontal = 1
	elif !Input.is_action_pressed("move_left") and !Input.is_action_pressed("move_right"):
		player.is_moving_horizontal = 0
	
	return State.Null
	
func process(_delta: float) -> int:
	return State.Null

func physics_process(_delta: float) -> int:
	return State.Null
	
func shoot(muzzle:Node2D) -> void:
	# Instantiate a bullet
	var new_bullet = bullet.instantiate()

	var new_position = Vector2((muzzle.global_position.x * player.direction) + player.position.x, 
			+ muzzle.global_position.y + player.position.y)
	new_bullet.set_position(new_position)
	
	if player.direction == -1:
		new_bullet.scale.y *= -1  #TODO
		new_bullet.direction = player.direction
		
	$".".add_child(new_bullet)
	
