extends Ability
class_name Fireball

@export
var shot_range: int = 4
@export
var sides: int = 4

var offsets: Array[Vector2i] = [
	Vector2i(-1,-1),
	Vector2i(0,-1),
	Vector2i(1,-1),
	Vector2i(-1,0),
	Vector2i(0,0),
	Vector2i(1,0),
	Vector2i(-1,1),
	Vector2i(0,1),
	Vector2i(1,1),
]

func _init() -> void:
	super._init(shot_range, 20, 6)
	name = "Fireball"
	icon.atlas = load("res://assets/TileSet.png")
	icon.region = Rect2i(16*2, 16*9, 16, 16)
	
func perform(caster: Entity, grid_pos: Vector2i) -> bool:
	for offset in offsets:
		var target: Entity = GameData.map_data.get_entity(grid_pos+offset)
		if target:
			Log.log(target.name() + " got hit with a fireball")
			current_cooldown = ability_cooldown
			target.combat.take_damage(caster.combat.get_damage(sides, Damage.Type.ARCANE))
	Sfx.play_zap()
	return false
