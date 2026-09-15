extends Generator
class_name SimpleRooms

@export
var min_room_size: Vector2i = Vector2i(5,5)
@export
var max_room_size: Vector2i = Vector2i(15,15)

@export
var enemies: Array[EntityDefinition] = [
	preload("uid://cq3c0nuktqibp"), # Goblin
	preload("uid://cx2o22hlo5n31")
]

var size: Vector2i

func generate(s: Vector2i, player: Entity) -> MapData:
	size = s
	map_data = MapData.new(size)
	
	var room_bounds: Array[Rect2i] = _make_rooms()
	
	var rooms: Array[Room] = []
	for bound in room_bounds:
		rooms.append(Room.new(bound))
	
	for room in rooms:
		_carve_room(room.bounds)
		
	for a in range(1, rooms.size()):
		_tunnel_between(rooms[a-1].bounds.get_center(), rooms[a].bounds.get_center())
	
	player.grid_pos = rooms[0].bounds.get_center()
	map_data.entities.append(player)
	map_data.get_tile(rooms[0].bounds.get_center()).set_definition(map_data.tile_set.doom_floor)
	
	map_data.get_tile(rooms.pick_random().bounds.get_center()).set_definition(map_data.tile_set.stairs)
	
	for room in rooms.slice(1):
		map_data.entities.append(Entity.new(room.bounds.get_center(), enemies.pick_random()))
	
	return map_data
	
func _make_rooms() -> Array[Rect2i]:
	var rooms: Array[Rect2i] = []
	var fail_count: int = 0
	while true:
		var room_size: Vector2i = Vector2i(
			randi_range(min_room_size.x, max_room_size.x),
			randi_range(min_room_size.y, max_room_size.y)
		)
		var pos: Vector2i = Vector2i(
			randi_range(1, size.x - room_size.x - 1),
			randi_range(1, size.y - room_size.y - 1)
		)
		var new_room = Rect2i(pos, room_size)
		if _overlaps(new_room, rooms):
			fail_count += 1
			if fail_count >= 50:
				return rooms
			continue
		rooms.append(new_room)
		fail_count = 0
	return rooms

func _overlaps(new_room: Rect2i, rooms: Array[Rect2i]) -> bool:
	for room in rooms:
		if new_room.grow(2).intersects(room.grow(1)):
			return true
	return false

func _carve_tile(x: int, y: int, tile: TileDefinition = map_data.tile_set.floor):
	map_data.get_tile_xy(x,y).set_definition(tile)

func _carve_room(rect: Rect2i) -> void:
	for x in range(rect.position.x, rect.end.x):
		for y in range(rect.position.y, rect.end.y):
			map_data.get_tile_xy(x,y).set_definition(map_data.tile_set.floor)

func _tunnel_horizontal(y: int, x_start: int, x_end: int) -> void:
	var x_min: int = mini(x_start, x_end)
	var x_max: int = maxi(x_start, x_end)
	for x in range(x_min, x_max + 1):
		_carve_tile(x, y)
		
func _tunnel_vertical(x: int, y_start: int, y_end: int) -> void:
	var y_min: int = mini(y_start, y_end)
	var y_max: int = maxi(y_start, y_end)
	for y in range(y_min, y_max + 1):
		_carve_tile(x, y)
		
func _tunnel_between(start: Vector2i, end: Vector2i) -> void:
	if randf() < 0.5:
		_tunnel_horizontal(start.y, start.x, end.x)
		_tunnel_vertical(end.x, start.y, end.y)
	else:
		_tunnel_vertical(start.x, start.y, end.y)
		_tunnel_horizontal(end.y, start.x, end.x)
