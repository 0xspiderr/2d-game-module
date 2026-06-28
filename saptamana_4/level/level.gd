extends Node2D

@onready var player: Player = $Player
const TILE_SIZE: int = 16

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_player_tool_used(tool: Player.Tool, offset: Vector2) -> void:
	var grid_pos: Vector2i = Vector2i(offset.x / TILE_SIZE, offset.y / TILE_SIZE)
	print(grid_pos)
	print(offset)
