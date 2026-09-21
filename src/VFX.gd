extends AnimatedSprite2D
class_name VFX

var grid_pos: Vector2i

func _ready() -> void:
	global_position = Grid.grid_to_world(grid_pos)
	animation_finished.connect(queue_free)
	play("default")
