extends Node2D
class_name BaseBullet

@export var damage:int = 1
@export var speed:float = 290.0
@export var direction: int = 1

enum BULLET_TYPE {
	NORMAL = 1,
	MEDIUM = 2,
	CHARGED = 3,
}

func _physics_process(delta: float) -> void:
	position.x += speed * delta * direction
	
