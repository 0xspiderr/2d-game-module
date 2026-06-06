extends CharacterBody2D

@export var _walking_speed: int = 50
var _current_speed: int = _walking_speed
var _running_speed: int = 100

var _direction: Vector2 = Vector2.ZERO
@onready var player_animated_sprite: AnimatedSprite2D = $PlayerAnimatedSprite
@onready var tool_animated_sprite: AnimatedSprite2D = $ToolAnimatedSprite

var _is_running: bool = false

func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	_direction = Input.get_vector("left", "right", "up", "down")
	_is_running = Input.is_action_pressed("run")
	print(_direction)
	
	_current_speed = _running_speed if _is_running else _walking_speed
	velocity = _direction * _current_speed
	
	if _direction.x != 0:
		player_animated_sprite.flip_h = _direction.x < 0
		tool_animated_sprite.flip_h = player_animated_sprite.flip_h
	
	# play animations based on direction value
	if _direction:
		player_animated_sprite.play("walk")
		tool_animated_sprite.play("walk")
	else:
		player_animated_sprite.play("idle")
		tool_animated_sprite.play("idle")
	
	move_and_slide()
