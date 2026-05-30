extends CharacterBody2D

@export var _speed: int = 50
var _direction: Vector2 = Vector2.ZERO
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	_direction = Input.get_vector("left", "right", "up", "down")
	print(_direction)
	velocity = _direction * _speed
	
	# play animations based on direction value
	if _direction:
		animated_sprite_2d.play("walk")
	else:
		animated_sprite_2d.play("idle")
	
	move_and_slide()
