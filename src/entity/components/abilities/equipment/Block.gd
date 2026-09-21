extends Ability
class_name Block

@export
var block: int = 1
@export
var duration: int = 1

func _init() -> void:
	super._init(0, 10, 0)
	name = "Lunge"
	icon.atlas = load("res://assets/TileSet.png")
	icon.region = Rect2i(16*6, 16*7, 16, 16)
	
func perform(caster: Entity, _grid_pos: Vector2i) -> bool:
	caster.apply_effect(BlockEffect.new(duration, block))
	return true
