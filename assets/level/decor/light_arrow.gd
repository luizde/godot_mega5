extends Node2D

@onready var color_switcher_over_time: ColorSwitcherOverTime = $ColorSwitcherOverTime
@onready var timer: Timer = $AnimatedSprite2D/Timer
@onready var sprites:AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	color_switcher_over_time.begin()
	timer.wait_time = 0.15
	timer.timeout.connect(_handle_timeout)
	timer.start()

func _handle_timeout() -> void:
	if timer.wait_time == 0.15:
		timer.wait_time = 0.40
		sprites.play("large")
		timer.start()
	else:
		timer.wait_time = 0.15
		sprites.play("small")
		GodotLogger.debug("Playing animation %s" % sprites.animation)
		timer.start()
