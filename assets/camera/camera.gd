extends Camera2D

@onready var player: Player = $"../megaman"

var scroll_speed_multiplier = 3.0

#var y_distance
var next_position: Vector2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.player_enters_room.connect(change_room)
	next_position = position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	position.x = player.position.x
	
	position.y = clampf(position.y + scroll_speed_multiplier, 0, next_position.y)
	
	
func change_room(_room_number: int, room_pos: Vector2, room_rect: Rect2) -> void:
	next_position.y = room_pos.y + 10 #TODO: need a better way here
	limit_left = room_rect.position.x + room_pos.x
	limit_right = room_pos.x + room_rect.size.x
	GodotLogger.debug("limit left is %s" % limit_left)
	GodotLogger.debug("limit right is %s" % limit_right)
	
