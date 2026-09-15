extends Ability
class_name ArcaneBolt

func _init() -> void:
	super._init(8, 3, 1)
	name = "Arcane Bolt"
	icon.atlas = load("res://assets/TileSet.png")
	icon.region = Rect2i(0, 16*9, 16, 16)
	
func perform(caster: Entity, grid_pos: Vector2i) -> bool:
	current_cooldown = ability_cooldown
	var target: Entity = GameData.map_data.get_entity(grid_pos)
	if target:
		Log.log(target.name() + " got shot with an arcane bolt")
		target.combat.take_damage(Damage.new(randi_range(1,6)+caster.combat.arcane, Damage.Type.ARCANE))
		return true
	return false
