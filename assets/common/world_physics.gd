extends Node

## This is basically a singleton with functions for altering gravity. Every
## object that responds to gravity should get it from here. It can also change
## (like underwater or in gravity man's stage) which is why we don't use a simple
## global variable of the physics engine

static var gravity: float :
	get:
		return gravity

const _GRAVITY_NORMAL: float = 15.0
const _GRAVITY_SCREEN_TRANSITION: float = 0.5
const _GRAVITY_UNDERWATER: float = 7.5

func _ready() -> void:
	change_gravity_to_normal()

static func change_gravity_for_screen_transition() -> void:
	gravity = _GRAVITY_SCREEN_TRANSITION

static func change_gravity_to_normal() -> void:
	gravity = _GRAVITY_NORMAL

static func change_gravity_underwater() -> void:
	gravity = _GRAVITY_UNDERWATER
