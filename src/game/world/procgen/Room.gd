extends RefCounted
class_name Room

var bounds: Rect2i

func _init(rect: Rect2i) -> void:
	bounds = rect

func rand_pos() -> Vector2i:
	return Vector2(randi_range(bounds.position.x+1, bounds.end.x-1), randi_range(bounds.position.y+1, bounds.end.y-1))
