extends Area2D
class_name BaseRoom

@export var room_number:int = 0

var room_rect:Rect2 :
	get:
		for child in get_children():
			if child is CollisionShape2D:
				return child.shape.get_rect()
		
		return Rect2()

func player_entered() -> void:
	EventBus.player_enters_room.emit(room_rect)
	print("room number %d :" % room_number)
	


func _on_body_entered(body: Node2D) -> void:
	player_entered()
