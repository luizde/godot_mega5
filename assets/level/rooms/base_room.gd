extends Area2D
class_name BaseRoom

@export var room_number:int = 0

var room_position:Vector2 :
	get:
		for child in get_children():
			if child is CollisionShape2D:
#				print("TO GLOBAL FROM ROOM %s" % to_global(child.position))
				return to_global(child.position)
		return Vector2(0, 0)

func _ready() -> void:
	EventBus.player_teleported_into_level.connect(enable_room_monitoring)

func _on_body_entered(_body: Node2D) -> void:
	EventBus.player_enters_room.emit(room_number, room_position)
	GodotLogger.info("Level begins in room_number %d" % room_number)

func enable_room_monitoring() -> void:
	monitoring = true
	