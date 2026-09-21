extends Ability
class_name ArcaneMind

@export
var duration: int = 20

func _init() -> void:
	super._init(0, 50, 0)
	name = "Arcane Mind"
	icon.atlas = load("res://assets/TileSet.png")
	icon.region = Rect2i(16*7, 16*7, 16, 16)
	
func perform(caster: Entity, _grid_pos: Vector2i) -> bool:
	caster.apply_effect(ArcaneMindEffect.new(duration))
	current_cooldown = ability_cooldown
	return true
