extends Node

@export var bullet: Resource

func shoot_bullet(shooter:Node2D, muzzle: Node2D, direction: int, charge_level: int = 0):
	var new_bullet  = bullet.instantiate()
	
	var new_position = Vector2((muzzle.global_position.x * direction) + shooter.position.x, 
			+ muzzle.global_position.y + shooter.position.y)
	new_bullet.set_position(new_position)
	
	if direction == -1:
		new_bullet.scale.y *= -1
		new_bullet.direction = direction #
	
	shooter.get_parent().add_child(new_bullet)
	
	new_bullet.set_bullet_type(charge_level)
	
	
	
