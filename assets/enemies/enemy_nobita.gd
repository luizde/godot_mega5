extends BaseEnemy

@export var limit_left: Node2D
@export var limit_right: Node2D

@export var speed_walk: float = 30.0
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

const ANIMATIONS = {
	IDLE = "idle",
	WALK = "walk",
	RISE = "rise"
}

var _direction:int = -1
var _next_direction: int = -1

func _ready() -> void:
	super()
	animation.play(ANIMATIONS.WALK)

func _process(_delta: float) -> void:
	if _direction == 1:
		animation.flip_h = true
	elif _direction == -1: 
		animation.flip_h = false

func _physics_process(_delta: float) -> void:
	super(_delta)
	velocity.x = speed_walk * _direction
	
	#if self.name == "enemy_nobita2":
		#GodotLogger.debug("%s position is %s " % [self.name, round(position.x)])
		#GodotLogger.debug("\tleft position is %s " % [round(limit_left.position.x)])
	#remember to_global should be called inside the parent
	if (round(position.x) == round(limit_left.position.x) and _direction == -1) \
	 		or (round(position.x) == round(limit_right.position.x) and _direction == 1):
		_next_direction *= -1
		_direction = 0
		
		animation.play(ANIMATIONS.RISE)
	
	move_and_slide()

func _on_animated_sprite_2d_animation_finished() -> void:
	if animation.animation == ANIMATIONS.RISE and animation.speed_scale > 0:
		animation.speed_scale = -1
		animation.play(ANIMATIONS.RISE)
	elif animation.animation == ANIMATIONS.RISE and animation.speed_scale < 0:
		animation.speed_scale = 1
		animation.play(ANIMATIONS.WALK)
		_direction = _next_direction
		
	


func _on_damage_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		send_damage()
