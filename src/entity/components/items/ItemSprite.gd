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

func cleanup() -> void:
	GameData.map_data.items.erase(self)
