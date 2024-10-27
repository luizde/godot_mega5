extends Node

## This is basically a singleton with functions for altering gravity. Every
## object that responds to gravity should get it from here. It can also change
## (like underwater or in gravity man's stage) which is why we don't use a simple
## global variable of the physics engine

static var gravity: float :
	get:
		return gravity

const _GRAVITY_NORMAL: float = 15.0
const _GRAVITY_SCREEN_TRANSITION: float = 0.2
const _GRAVITY_UNDERWATER: float = 7.5

static var screen_transition_timer: Timer

func _ready() -> void:
	change_gravity_to_normal()
	
	screen_transition_timer = Timer.new()
	screen_transition_timer.set_wait_time(1.25)
	screen_transition_timer.one_shot = true
	add_child(screen_transition_timer)
	
	screen_transition_timer.timeout.connect(change_gravity_to_normal)
	
	EventBus.player_enters_room.connect(handle_room_enter)

static func change_gravity_for_screen_transition() -> void:
	screen_transition_timer.start()
	gravity = _GRAVITY_SCREEN_TRANSITION

static func change_gravity_to_normal() -> void:
	gravity = _GRAVITY_NORMAL

static func change_gravity_underwater() -> void:
	gravity = _GRAVITY_UNDERWATER

static func transition_screen() -> void:
	change_gravity_for_screen_transition()

func handle_room_enter(room_number: int, room_position: Vector2):
	change_gravity_for_screen_transition()
	
