extends BaseState

var dead_particle = preload("res://assets/megaman/megaman_dead_particle.tscn")

func enter() -> void:
	super()
	
	MiscUtils.setDisabledForChildrenCollisionShapes(get_node("../../"), true, true)
	#MiscUtils.setDisabledForChildrenSprite2D(get_node("../../"), true, true)
	
	#we need 6 directions
	var directions = [0, 45, 90, 135, 180, 225, 270, 315]
	for i in directions.size():
		# Instantiate a bullet
		var particle:Node2D = dead_particle.instantiate()

		particle.set_position(player.position)
		
		particle.rotate(deg_to_rad(directions[i]))

		print(particle.rotation_degrees)
		#particle.rotate()
		
		$".".add_child(particle)


func input(_event: InputEvent) -> int:
	#No inputs available
	return BaseState.State.Null
