extends Ability
class_name ArrowShot

@export
var arrow_range: int = 4
@export
var sides: int = 4

func _init() -> void:
	super._init(arrow_range, 0, 0)
	name = "Arrow Shot"
	icon.atlas = load("res://assets/TileSet.png")
	icon.region = Rect2i(16, 16*7, 16, 16)
	
func perform(caster: Entity, grid_pos: Vector2i) -> bool:
	var target: Entity = GameData.map_data.get_entity(grid_pos)
	if target:
		Log.log(target.name() + " got shot with an arrow")
		current_cooldown = ability_cooldown
		target.combat.take_damage(caster.combat.get_damage(sides, Damage.Type.NORMAL))
		Sfx.play_zap()
		return true
	return false
