extends CanvasLayer

@onready var hp_bars: Node = $HPBars

var HPBars: Array[Sprite2D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#register events
	EventBus.player_hp_changed.connect(player_hp_changed)
	
	#collect references to HP
	HPBars = []
	for child in hp_bars.get_children():
		HPBars.append(child)


func player_hp_changed(new_hp) -> void:
	var i = 0
	for bar in HPBars:
		if i < new_hp:
			bar.visible = true
		else:
			bar.visible = false
		i += 1
