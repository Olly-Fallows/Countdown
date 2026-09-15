extends Sprite2D
class_name Tile

var light_level: float = 0:
	set(value):
		if value > 0:
			is_in_view = true
			modulate = _definition.colour.lerp(_definition.colour_dark, value-0.1)
		else:
			modulate = _definition.colour_dark
		light_level = value

var is_explored: bool = false:
	set(value):
		is_explored = value
		if is_explored and not visible:
			visible = true

var is_in_view: bool = false:
	set(value):
		is_in_view = value
		#modulate = _definition.colour if is_in_view else _definition.colour_dark
		if is_in_view and not is_explored:
			is_explored = true

var grid_pos: Vector2i:
	set(value):
		grid_pos = value
		global_position = Grid.grid_to_world(value)

var _definition: TileDefinition

var effects: Array[TileEffect] = []

func _init(pos: Vector2i, tile_definition: TileDefinition) -> void:
	visible = false
	grid_pos = pos
	set_definition(tile_definition)
	
func set_definition(definition: TileDefinition) -> void:
	_definition = definition
	texture = _definition.icon
	if light_level > 0:
		is_in_view = true
		modulate = _definition.colour.lerp(_definition.colour_dark, light_level-0.1)
	else:
		modulate = _definition.colour_dark
		
	effects = []
	for effect in _definition.effects:
		effects.append(effect.duplicate())

func do_passives() -> void:
	for effect in effects:
		effect.passive(self)

func apply_effects(entity: Entity) -> void:
	for effect in effects:
		effect.apply(entity)

func is_exit() -> bool:
	for effect in effects:
		if effect is NextLevel:
			return true
	return false

func has_doom() -> bool:
	for effect in effects:
		if effect is Doom:
			return true
	return false

func is_transparent() -> bool:
	return _definition.is_transparent

func is_traversable() -> bool:
	return _definition.is_walkable

func is_type(def: TileDefinition) -> bool:
	return def == _definition

func colour() -> Color:
	return _definition.colour
