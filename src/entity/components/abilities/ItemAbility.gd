extends Ability
class_name ItemAbility

var item: Item

func _init(i: Item) -> void:
	item = i
	super._init(i.use.item_range, 0, 0)
	name = i.name
	icon = i.icon

func perform(_caster: Entity, grid_pos: Vector2i) -> bool:
	item.use.use(grid_pos)
	return true
