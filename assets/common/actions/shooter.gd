extends Node
class_name Shooter

@export var bullet: Resource

func shoot_bullet(shooter:Node2D, muzzle: Vector2, direction: int, charge_level: int = 0):
	var new_bullet  = bullet.instantiate()
	
	#var new_position = Vector2((muzzle.global_position.x * direction) + shooter.position.x, 
			#+ muzzle.global_position.y + shooter.position.y)
			
	var new_position = shooter.to_global(muzzle)
	
	new_bullet.set_position(new_position)
	
	if direction == -1:
		new_bullet.scale.y *= -1
		new_bullet.direction = direction
	
	shooter.add_child(new_bullet)
	new_bullet.top_level = true
	
	if charge_level > 0:
		new_bullet.set_bullet_type(charge_level)
	
	
	
