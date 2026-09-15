@abstract
extends Resource
class_name Generator

var map_data: MapData

@abstract
func generate(s: Vector2i, player: Entity) -> MapData
