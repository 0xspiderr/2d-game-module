extends Node2D

@onready var player: Player = $Player
const TILE_SIZE: int = 16
@onready var dirt_layer: TileMapLayer = $DirtLayer
@onready var water_dirt_layer: TileMapLayer = $WaterDirtLayer

enum CellType {
	DIRT = 0,
	WATER
}
@export var _atlas_coordinates: Dictionary[CellType, Vector2i]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_player_tool_used(tool: Player.Tool, offset: Vector2) -> void:
	var grid_pos: Vector2i = Vector2i(int(offset.x / TILE_SIZE), int(offset.y / TILE_SIZE))
	match tool:
		Player.Tool.DIG:
			dirt_layer.set_cells_terrain_connect([grid_pos], 0, 0, false)
		Player.Tool.WATER:
			var dirt_data := dirt_layer.get_cell_tile_data(grid_pos)
			if not dirt_data:
				return
			var can_water = dirt_data.get_custom_data("can_water")
			if can_water:
				# ....
				print("can water")
				water_dirt_layer.set_cell(grid_pos, 0, _atlas_coordinates[CellType.WATER])

#
#
#
