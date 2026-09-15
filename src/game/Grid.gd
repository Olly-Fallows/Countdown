extends Node
class_name Grid

static var tile_size: Vector2i = Vector2i(16,16)

static func grid_to_world(pos: Vector2i) -> Vector2:
	return pos * tile_size

static func world_to_grid(pos: Vector2) -> Vector2i:
	@warning_ignore("integer_division")
	return Vector2i(pos) / tile_size
