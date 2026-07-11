extends StaticBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func grow_plant() -> void:
	print("a crescut planta")
	if animated_sprite_2d.frame < animated_sprite_2d.sprite_frames.get_frame_count("carrot"):
		animated_sprite_2d.frame += 1
