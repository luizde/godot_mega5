extends BaseEnemy

const BULLET = preload("res://assets/enemies/bullets/enemy_bullet.tscn")
@onready var muzzle: Node2D = $Muzzle

@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var shoot_timer: Timer = $ShootTimer

func _ready() -> void:
	super()
	damage_shot = 2
	damage_touch = 4
	enemy_name = "suzy_g"
	hp = 3

func _on_body_entered(_body: Node2D) -> void:
	EventBus.enemy_hit_player.emit("suzy_g", damage_touch)

func shoot() -> void:
	var new_bullet = BULLET.instantiate()
	
	var direction = -1
	
	if sprite_2d.flip_h == true:
		direction = 1
	
	var new_position = Vector2(muzzle.global_position.x, 
			+ muzzle.global_position.y)
			
	print("global position x %s" % new_position)
	
	new_bullet.set_position(new_position)
	
	new_bullet.direction = direction
	
	$"../".add_child(new_bullet)


func _on_shoot_timer_timeout() -> void:
	shoot()


func _on_detection_range_body_entered(body: Node2D) -> void:
	shoot_timer.start()
	print("megaman is close")


func _on_detection_range_body_exited(body: Node2D) -> void:
	shoot_timer.stop()
	print("megaman is far")
