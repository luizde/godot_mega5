extends BaseEnemy

#const BULLET = preload("res://assets/enemies/bullets/enemy_bullet.tscn")
@onready var muzzle: Node2D = $Muzzle

@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var shoot_timer: Timer = $ShootTimer
@onready var shooter: Node = $Shooter

func _ready() -> void:
	super()
	damage_shot = 2
	damage_touch = 4
	enemy_name = "suzy_g"
	hp = 3

func _on_body_entered(_body: Node2D) -> void:
	EventBus.enemy_hit_player.emit("suzy_g", damage_touch)

func _on_shoot_timer_timeout() -> void:
	shooter.shoot_bullet(self, Vector2(muzzle_position_x * player_direction, muzzle_position_y), \
			player_direction)
	sprite_2d.play("shoot")


func _on_detection_range_body_entered(_body: Node2D) -> void:
	shoot_timer.start()

func _on_detection_range_body_exited(_body: Node2D) -> void:
	shoot_timer.stop()



func _process(_delta: float) -> void:
	super(_delta)
	if shoot_timer.time_left < shoot_timer.wait_time * 0.8 and sprite_2d.animation == "shoot":
		sprite_2d.play("idle")
	#GodotLogger.debug("Player position is %d" % player_direction)
