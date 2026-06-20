extends Node2D

@onready var player: Player = $Player


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_player_tool_used(tool: Player.Tool, offset: Vector2) -> void:
	print("asfddsa")
	print(offset)
