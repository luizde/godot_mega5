extends Node

# using Enums for state names. That way every script has the same interface
# while being more robust and error prone than using strings
@onready var states = {
	BaseState.State.Idle: $Idle,
	BaseState.State.Step: $Step,
	BaseState.State.Walk: $Walk,
	BaseState.State.Jump: $Jump,
	BaseState.State.Fall: $Fall,
	BaseState.State.Slide: $Slide,
	BaseState.State.Damaged: $Damaged,
	BaseState.State.Dead: $Dead,
	BaseState.State.Teleport: $Teleport,
	BaseState.State.Ladder: $Ladder
}

var current_state: BaseState

func change_state(new_state: int) -> void:
	if current_state:
		current_state.exit()# Luis: I assume this has to happen cause we're leaving
							# the state. The if only checks if not Null I guess
	
	current_state = states[new_state]
	current_state.enter()

func init(player: Player) -> void:
	
	for child in get_children():
		child.player = player
	
	# We initialize on Idle always 
	change_state(BaseState.State.Teleport)
	
# Pass thru functions for the player to call handling states as needed
func physics_process(delta: float) -> void:
	var new_state = current_state.physics_process(delta)
	
	if new_state != BaseState.State.Null:
		change_state(new_state)

func input(event: InputEvent) -> void:
	var new_state = current_state.input(event)
	
	if new_state != BaseState.State.Null:
		change_state(new_state)
		
