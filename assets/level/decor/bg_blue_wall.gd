extends Node2D

@onready var top: AnimatedSprite2D = $top
@onready var mid: AnimatedSprite2D = $mid
@onready var bottom: AnimatedSprite2D = $bottom


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.player_started_moving_lateral.connect(start_anims)
	EventBus.player_stopped_moving_lateral.connect(stop_anims)


func start_anims() -> void:
	top.play("top")
	mid.play("mid")
	bottom.play("bottom")

func stop_anims() -> void:
	top.stop()
	mid.stop()
	bottom.stop()
