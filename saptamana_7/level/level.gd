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
const PLANT = preload("uid://gc0vipe2g5t4")
@onready var plants: Node2D = $Plants
var planted_cells: Dictionary[Vector2i, Plant]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_player_tool_used(tool: Player.Tool, offset: Vector2) -> void:
	var grid_pos: Vector2i = Vector2i(floor(offset.x / TILE_SIZE), floor(offset.y / TILE_SIZE))
	#print(grid_pos)
	#print(offset)
	match tool:
		Player.Tool.DIG:
			dirt_layer.set_cells_terrain_connect([grid_pos], 0, 0, false)
			if planted_cells.has(grid_pos):
				planted_cells[grid_pos].animate_on_ground()
				planted_cells.erase(grid_pos)
		Player.Tool.WATER:
			var dirt_data := dirt_layer.get_cell_tile_data(grid_pos)
			if not dirt_data:
				return
			var can_water = dirt_data.get_custom_data("can_water")
			if can_water:
				# ....
				print("can water")
				water_dirt_layer.set_cell(grid_pos, 0, _atlas_coordinates[CellType.WATER])
		Player.Tool.CARRY:
			var dirt_data := dirt_layer.get_cell_tile_data(grid_pos)
			if not dirt_data:
				return
			
			if not grid_pos in planted_cells:
				var plant = PLANT.instantiate() as Plant
				plant.position = (TILE_SIZE * grid_pos) + Vector2i(TILE_SIZE / 2, TILE_SIZE / 3)
				plants.add_child(plant)
				plant.grid_pos = grid_pos
				print("am spawnat o planta")
				planted_cells[grid_pos] = plant

func _on_time_manager_timeout() -> void:
	var plant_nodes = get_tree().get_nodes_in_group("plants")
	for plant: Plant in plant_nodes:
		if water_dirt_layer.get_cell_tile_data(plant.grid_pos) != null:
			plant.grow_plant()
