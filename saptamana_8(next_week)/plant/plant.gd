class_name Plant extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var grid_pos: Vector2i = Vector2i.ZERO
const RADIUS: float = 12.0
var last_frame: int

func _ready() -> void:
	last_frame = animated_sprite_2d.sprite_frames.get_frame_count("carrot") - 1

func grow_plant() -> void:
	if animated_sprite_2d.frame < last_frame - 1:
		animated_sprite_2d.frame += 1

func animate_on_ground() -> void:
	var x: float = randf_range(-RADIUS, RADIUS)
	var y: float = randf_range(-RADIUS, RADIUS)
	var final_pos: Vector2 = position + Vector2(x, y)
	animated_sprite_2d.frame = last_frame
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "position", final_pos, 0.2)


func _on_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
	
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, 0.2)
	await tween.finished
	PlayerData.add_plant("carrot")
	queue_free()
