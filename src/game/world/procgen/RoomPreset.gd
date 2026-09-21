extends Resource
class_name RoomPreset

@export_multiline("monospace", "no_wrap")
var layout: String = ""

@export
var tile_key: Dictionary[String, String] = {
	".": "floor",
	"#": "wall",
	"*": "spawn",
	"+": "cage",
	"c": "crystal",
	"s": "stairs",
	"d": "door"
}

func place(map_data: MapData, room: Room) -> void:
	var rows: PackedStringArray = layout.split("\n")
	@warning_ignore_start("integer_division")
	var offset: Vector2i = room.bounds.grow(-2).get_center()
	offset -= floor(Vector2i(rows[0].length(), rows.size()) / 2)
	for y in range(0, rows.size()):
		for x in range(0, rows[0].length()):
			if tile_key[rows[y][x]] == "spawn":
				map_data.get_tile_xy(x+offset.x,y+offset.y).set_definition(map_data.tile_set.floor)
			else:
				map_data.get_tile_xy(x+offset.x,y+offset.y).set_definition(map_data.tile_set[tile_key[rows[y][x]]])

func can_be(room: Room) -> bool:
	var rect = room.bounds.grow(-2)
	if rect.size.x > 0 and rect.size.y > 0:
		return rect.encloses(Rect2i(rect.position, Vector2i(layout.split("\n")[0].length(), layout.split("\n").size())))
	return false

func get_size() -> Vector2i:
	return Vector2i(layout.split("\n")[0].length(), layout.split("\n").size())

func spawn_positions(room: Room) -> Array[Vector2i]:
	var positions: Array[Vector2i] = []
	var rows: PackedStringArray = layout.split("\n")
	var offset: Vector2i = room.bounds.grow(-2).get_center()
	offset -= floor(Vector2i(rows[0].length(), rows.size()) / 2)
	for y in range(0, rows.size()):
		for x in range(0, rows[0].length()):
			if tile_key[rows[y][x]] == "spawn":
				positions.append(Vector2i(x+offset.x,y+offset.y))
	return positions
