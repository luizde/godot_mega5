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
	
	new_bullet.direction = direction
	
	add_child(new_bullet)
	
	var new_position = Vector2(muzzle.position.x, 
			+ muzzle.position.y)
	
	new_bullet.set_position(new_position)

func _on_shoot_timer_timeout() -> void:
	shoot()
	sprite_2d.play("shoot")


func _on_detection_range_body_entered(_body: Node2D) -> void:
	shoot_timer.start()


func _on_detection_range_body_exited(_body: Node2D) -> void:
	shoot_timer.stop()
	

func _process(_delta: float) -> void:
	if shoot_timer.time_left < shoot_timer.wait_time * 0.8 and sprite_2d.animation == "shoot":
		sprite_2d.play("idle")
