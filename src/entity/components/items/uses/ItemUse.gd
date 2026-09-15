@abstract
extends Resource
class_name ItemUse

@export
var item_range: int = 8

@abstract
func use(_pos: Vector2i) -> void
