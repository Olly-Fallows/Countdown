extends Resource
class_name TileDefinition

@export_category("Visuals")
@export
var icon: AtlasTexture
@export
var colour: Color = Color.WHITE
@export
var colour_dark: Color = Color(0.0, 0.0, 0.268, 1.0)

@export_category("Mechanics")
@export
var is_walkable: bool = true
@export
var is_transparent: bool = true
@export
var effects: Array[TileEffect] = []
