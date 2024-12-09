extends BaseEnemy

@onready var shooter: Shooter = $Shooter
@onready var muzzle: Node2D = $Muzzle
@onready var detection_range: Area2D = $DetectionRange
@onready var timer_cooldown: Timer = $TimerCooldown

func _ready() -> void:
	super()

func _process(_delta: float) -> void:
	look_at_player(false)
	


func _on_detection_range_body_entered(_body: Node2D) -> void:
	animated_sprite_2d.play("rise_shoot")


func _on_detection_range_body_exited(_body: Node2D) -> void:
	pass #animated_sprite_2d.play("idle")

func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "rise_shoot":
		shooter.shoot_bullet(self, muzzle.position, -1)
		animated_sprite_2d.play("lower")
	elif animated_sprite_2d.animation == "lower":
		detection_range.monitoring = false
		animated_sprite_2d.play("idle")
		timer_cooldown.start()


func _on_timer_cooldown_timeout() -> void:
	detection_range.monitoring = true
