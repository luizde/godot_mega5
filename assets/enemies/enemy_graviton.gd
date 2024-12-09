extends BaseEnemy

@onready var timer_shoot: Timer = $ShootTimer
@onready var muzzle: Node2D = $Muzzle
@onready var shooter: Shooter = $Shooter

func _ready() -> void:
	super()
	animated_sprite_2d.play("idle")
	
func _process(_delta) -> void:
	super(_delta)
	

func _on_shoot_timer_timeout() -> void:
	shooter.shoot_bullet(self, muzzle.position, 1)


func _on_detection_range_body_entered(_body: Node2D) -> void:
	timer_shoot.start()


func _on_detection_range_body_exited(_body: Node2D) -> void:
	timer_shoot.stop()
