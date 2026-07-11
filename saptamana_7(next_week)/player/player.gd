class_name Player extends CharacterBody2D

@export var _walking_speed: int = 50
var _current_speed: int = _walking_speed
var _running_speed: int = 100

var _direction: Vector2 = Vector2.ZERO
@onready var player_animated_sprite: AnimatedSprite2D = $PlayerAnimatedSprite
@onready var tool_animated_sprite: AnimatedSprite2D = $ToolAnimatedSprite

var _is_running: bool = false
var _facing_right: bool = true:
	set(value):
		_facing_right = value
		player_animated_sprite.flip_h = not value
		tool_animated_sprite.flip_h = not value
var _player_interacted: bool = false


enum Tool {
	WATER,
	DIG,
	CARRY
}
var _current_tool: Tool = Tool.WATER

signal tool_used(tool: Tool, offset: Vector2)

enum State {
	IDLE,
	WALKING,
	RUNNING,
	TOOL_USED
}
var _current_state: State = State.IDLE
const TOOL_LEFT: float = -1.0
const TOOL_RIGHT: float = 1.0
const TOOL_OFFSET: float = 12.0

func _set_state(new_state: State) -> void:
	if _current_state == new_state:
		return
	
	# modify current state to the new state
	_current_state = new_state
	
	match _current_state:
		State.IDLE:
			_player_animate("idle")
		State.WALKING:
			_player_animate("walk")
		State.RUNNING:
			_player_animate("run")
		State.TOOL_USED:
			_play_tool_animation()
		_:
			print("state not found")

func _update_state() -> void:
	match _current_state:
		State.IDLE, State.WALKING, State.RUNNING:
			_player_move()
			if velocity == Vector2.ZERO:
				_set_state(State.IDLE)
			elif _is_running:
				_set_state(State.RUNNING)
			else:
				_set_state(State.WALKING)
			
			if _player_interacted:
				_set_state(State.TOOL_USED)
		State.TOOL_USED:
			velocity = Vector2.ZERO
#region GODOT BUILT-IN METHODS
func _ready() -> void:
	pass


func _input(event: InputEvent) -> void:
	_player_interacted = Input.is_action_pressed("click")
	
	_direction = Input.get_vector("left", "right", "up", "down")
	_is_running = Input.is_action_pressed("run")
	if Input.is_action_pressed("tool_switch_up"):
		_switch_tool(1)
	elif Input.is_action_pressed("tool_switch_down"):
		_switch_tool(-1)


func _physics_process(delta: float) -> void:
	_update_state()
	move_and_slide()
#endregion

#region PLAYER METHODS
func _player_move() -> void:
	_current_speed = _running_speed if _is_running else _walking_speed
	velocity = _direction * _current_speed
	
	if _direction.x != 0:
		_facing_right = _direction.x > 0
	

func _player_animate(anim_name: String) -> void:
	# check that the animation name exists in the animation components
	player_animated_sprite.play(anim_name)
	tool_animated_sprite.play(anim_name)
#endregion

#region TOOL METHODS
func _switch_tool(switch_direction: int) -> void:
	_current_tool = (_current_tool + switch_direction + Tool.size()) % Tool.size()
	print(_current_tool)
	print(Tool.keys()[_current_tool])

func _play_tool_animation() -> void:
	var tool_anim_name: String = Tool.keys()[_current_tool]
	player_animated_sprite.play(tool_anim_name.to_lower())
	tool_animated_sprite.play(tool_anim_name.to_lower())
	await player_animated_sprite.animation_finished
	await tool_animated_sprite.animation_finished
	var tool_dir: float = TOOL_RIGHT if _facing_right else TOOL_LEFT
	print(tool_dir)
	var pos_offset: Vector2 = position + Vector2(tool_dir * TOOL_OFFSET, 6.0)
	tool_used.emit(_current_tool, pos_offset)
	
	_set_state(State.IDLE)
#endregion
