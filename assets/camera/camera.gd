extends Camera2D

@onready var player: Player = $"../megaman"

#region Screen Shake vars
@export var screen_shake_strength: float = 15.0
## how fast the shake recedes. larger means faster
@export var screen_shake_fade:float = 8.0
var _rng: RandomNumberGenerator = RandomNumberGenerator.new()
var _shake_strength: float = 0.0
#endregion 

var scroll_speed_multiplier = 3.0

#var y_distance
var next_position: Vector2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.player_enters_room.connect(change_room)
	next_position = position
	EventBus.enemy_hit_player.connect(_handle_screen_shake)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	position.x = player.position.x
	
	position.y = clampf(position.y + scroll_speed_multiplier, -10000, next_position.y)
	
	if _shake_strength > 0.0:
		_shake_strength = lerpf(_shake_strength, 0, screen_shake_fade * _delta)
		offset = _random_offset()
	
	
func change_room(_room_number: int, room_pos: Vector2, room_rect: Rect2) -> void:
	next_position.y = room_pos.y + 10 #TODO: need a better way here
	GodotLogger.debug("New room position is %s " % room_pos.y)
	#it's late but his math works so trust me bro
	limit_left = room_rect.position.x + room_pos.x
	limit_right = (room_rect.position.x + room_pos.x) + room_rect.size.x 
	
func _handle_screen_shake(_enemy_name: String, damage_hp: int) -> void:
	_shake_strength = screen_shake_strength

func _random_offset() -> Vector2:
	return Vector2( _rng.randf_range(-_shake_strength, _shake_strength),\
			_rng.randf_range(-_shake_strength, _shake_strength))
