extends Node

@export var player: Player

var _previous_position_x:float = 0
var _tmpx : float = 0
var _emmitted_move:bool = false
var _emmitted_stop:bool = false

func _ready() -> void:
	_previous_position_x = player.position.x


func _physics_process(_delta: float) -> void:
	
	if _previous_position_x != player.position.x and !_emmitted_move:
		EventBus.player_started_moving_lateral.emit()
		_emmitted_move = true
		_emmitted_stop = false
	elif _previous_position_x == player.position.x and !_emmitted_stop:
		EventBus.player_stopped_moving_lateral.emit()
		_emmitted_stop = true
		_emmitted_move = false
		
	_previous_position_x = player.position.x
	
	
	
	
