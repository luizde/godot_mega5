extends BaseBullet

@onready var sprites: AnimatedSprite2D = $Sprites

@onready var collider: CollisionShape2D = $Collider

func set_bullet_type(type : BULLET_TYPE):
	
	damage = type
	match type:
		BULLET_TYPE.NORMAL:
			collider.scale = Vector2(1,1)
			sprites.play("low")
		BULLET_TYPE.MEDIUM:
			collider.scale = Vector2(3,3)
			sprites.play("medium")
		BULLET_TYPE.CHARGED:
			collider.scale = Vector2(3,3)
			sprites.play("charged")

func _on_body_entered(_body: Node2D) -> void:
	EventBus.player_hit_enemy_normalshot.emit(damage)
	queue_free()


func _on_area_entered(_area: Area2D) -> void:
	EventBus.player_hit_enemy_normalshot.emit(damage)
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
