@abstract
extends Resource
class_name TileEffect

@abstract
func apply(entity: Entity) -> void

@abstract
func passive(tile: Tile) -> void
