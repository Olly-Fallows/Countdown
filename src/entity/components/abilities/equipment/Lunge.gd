extends Ability
class_name Lunge

@export
var distance: int = 2

func _init() -> void:
	super._init(1, 20, 0)
	name = "Lunge"
	icon.atlas = load("res://assets/TileSet.png")
	icon.region = Rect2i(0, 16*7, 16, 16)
	
func perform(caster: Entity, grid_pos: Vector2i) -> bool:
	var direction = (grid_pos - caster.grid_pos)
	if direction.length() == 0:
		return false
	if abs(direction.x) >= abs(direction.y):
		direction = Vector2i(sign(direction.x), 0)
	else:
		direction = Vector2i(0, sign(direction.y))
	for count in range(distance):
		await BumpAction.new(direction).perform(caster)
	current_cooldown = ability_cooldown
	return true
