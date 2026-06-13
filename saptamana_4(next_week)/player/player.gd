extends CharacterBody2D

@export var _walking_speed: int = 50
var _current_speed: int = _walking_speed
var _running_speed: int = 100

var _direction: Vector2 = Vector2.ZERO
@onready var player_animated_sprite: AnimatedSprite2D = $PlayerAnimatedSprite
@onready var tool_animated_sprite: AnimatedSprite2D = $ToolAnimatedSprite

var _is_running: bool = false
var _facing_right: bool = true:
	set(value):
		player_animated_sprite.flip_h = not value
		tool_animated_sprite.flip_h = not value
var _can_move: bool = true


enum Tool {
	WATER,
	DIG
}
var _current_tool: Tool = Tool.WATER

#region GODOT BUILT-IN METHODS
func _ready() -> void:
	pass


func _input(event: InputEvent) -> void:
	_direction = Input.get_vector("left", "right", "up", "down")
	_is_running = Input.is_action_pressed("run")
	if Input.is_action_pressed("tool_switch_up"):
		_switch_tool(1)
	elif Input.is_action_pressed("tool_switch_down"):
		_switch_tool(-1)
	
	if Input.is_action_pressed("click"):
		var tool_anim_name: String = Tool.keys()[_current_tool]
		player_animated_sprite.play(tool_anim_name.to_lower())
		tool_animated_sprite.play(tool_anim_name.to_lower())
		_can_move = false
		await player_animated_sprite.animation_finished
		await tool_animated_sprite.animation_finished
		_can_move = true


func _physics_process(delta: float) -> void:
	if not _can_move:
		return
	_player_move()
	move_and_slide()


func _process(delta: float) -> void:
	if not _can_move:
		return
	_player_animate()
#endregion

#region PLAYER METHODS
func _player_move() -> void:
	_current_speed = _running_speed if _is_running else _walking_speed
	velocity = _direction * _current_speed
	
	if _direction.x != 0:
		_facing_right = _direction.x > 0
	

func _player_animate() -> void:
	# play animations based on direction value
	if _is_running:
		player_animated_sprite.play("run")
		tool_animated_sprite.play("run")
	elif _direction != Vector2.ZERO:
		player_animated_sprite.play("walk")
		tool_animated_sprite.play("walk")
	else:
		player_animated_sprite.play("idle")
		tool_animated_sprite.play("idle")

func _switch_tool(switch_direction: int) -> void:
	_current_tool = (_current_tool + switch_direction + Tool.size()) % Tool.size()
	print(_current_tool)
	print(Tool.keys()[_current_tool])
#endregion
