extends Sprite2D
class_name ItemSprite

var item: Item
var grid_pos: Vector2i:
	set(value):
		grid_pos = value
		global_position = Grid.grid_to_world(value)

func _init(i: Item, pos: Vector2i) -> void:
	item = i
	texture = item.icon
	modulate = item.colour
	grid_pos = pos
	
	tree_exiting.connect(cleanup)
	GameData.turn_taken.connect(calc_visible)
	calc_visible()
	
func calc_visible() -> void:
	visible = GameData.map_data.get_tile(grid_pos).is_in_view

func cleanup() -> void:
	GameData.map_data.items.erase(self)
