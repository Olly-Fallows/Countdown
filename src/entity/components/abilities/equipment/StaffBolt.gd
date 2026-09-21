extends Ability
class_name StaffBolt

@export
var shot_range: int = 4
@export
var sides: int = 2

func _init() -> void:
	super._init(shot_range, 3, 4)
	name = "Staff Shot"
	icon.atlas = load("res://assets/TileSet.png")
	icon.region = Rect2i(16*3, 16*9, 16, 16)
	
func perform(caster: Entity, grid_pos: Vector2i) -> bool:
	var target: Entity = GameData.map_data.get_entity(grid_pos)
	if target:
		var direction = (grid_pos - caster.grid_pos)
		if direction.length() == 0:
			return false
		if abs(direction.x) >= abs(direction.y):
			direction = Vector2i(sign(direction.x), 0)
		else:
			direction = Vector2i(0, sign(direction.y))
		Log.log(target.name() + " got shot with an staff bolt")
		current_cooldown = ability_cooldown
		await MoveAction.new(direction).perform(target)
		target.combat.take_damage(caster.combat.get_damage(sides, Damage.Type.ARCANE))
		Sfx.play_zap()
		return true
	return false
