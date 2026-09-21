extends Generator
class_name SimpleRooms

@export
var min_room_size: Vector2i = Vector2i(5,5)
@export
var max_room_size: Vector2i = Vector2i(15,15)

@export
var max_per_room: int = 1
@export
var min_per_room: int = 1

@export
var enemies: Array[EntityDefinition] = [
	preload("uid://cq3c0nuktqibp"), # Goblin
	preload("uid://cx2o22hlo5n31")
]

var size: Vector2i

var rooms: Array[Room] = []

@export
var room_options: Array[RoomPreset] = [
	preload("uid://vfp628ues6sq")
]

func generate(s: Vector2i, player: Entity) -> MapData:
	rooms = []
	size = s
	map_data = MapData.new(size)
	
	var room_bounds: Array[Rect2i] = _make_rooms()
	
	for bound in room_bounds:
		rooms.append(Room.new(bound))
	
	# Spawn player
	player.grid_pos = rooms[0].bounds.get_center()
	map_data.entities.append(player)
	
	for room in rooms:
		_carve_room(room.bounds)
		var counter: int = 0
		var spawned: int = 0
		if room != rooms[0]:
			while true:
				var option = room_options.pick_random()
				if option.can_be(room):
					option.place(map_data, room)
					var positions: Array[Vector2i] = option.spawn_positions(room)
					for pos in positions:
						if (pos - player.grid_pos).length() > 4:
							if not map_data.get_entity(pos):
								if map_data.is_traversable(pos):
									map_data.entities.append(Entity.new(pos, enemies.pick_random()))
					break
				else:
					counter += 1
					if counter > 10:
						break
			for x in range(randi_range(max(0, min_per_room-spawned), max(0, max_per_room-spawned))):
				var pos = room.rand_pos()
				if (pos - player.grid_pos).length() > 4:
					if not map_data.get_entity(pos):
						if map_data.is_traversable(pos):
							map_data.entities.append(Entity.new(pos, enemies.pick_random()))
	
	# Spawn princess
	var princess_offset: Vector2i = [Vector2i(1,0),Vector2i(-1,0),Vector2i(0,1),Vector2i(0,-1)].pick_random()
	map_data.entities.insert(0, Entity.new(player.grid_pos+princess_offset, preload("uid://0c4f8lp0hfwc")))
	map_data.get_tile(player.grid_pos+princess_offset).set_definition(map_data.tile_set.doom_floor)
	
	for a in range(1, rooms.size()):
		_tunnel_between(rooms[a-1].bounds.get_center(), rooms[a].bounds.get_center())
	
	var stairs_room: Room = rooms[1]
	for room in rooms:
		if (room.bounds.get_center()-rooms[0].bounds.get_center()).length() > (stairs_room.bounds.get_center()-rooms[0].bounds.get_center()).length():
			stairs_room = room
	var chest_pos = stairs_room.rand_pos()
	while not map_data.is_traversable(chest_pos):
		chest_pos = stairs_room.rand_pos()
	map_data.get_tile(chest_pos).set_definition(map_data.tile_set.stairs)
	
	return map_data
	
func _make_rooms() -> Array[Rect2i]:
	var room_rects: Array[Rect2i] = []
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
		if _overlaps(new_room, room_rects):
			fail_count += 1
			if fail_count >= 50:
				return room_rects
			continue
		room_rects.append(new_room)
		fail_count = 0
	return room_rects

func _overlaps(new_room: Rect2i, room_rects: Array[Rect2i]) -> bool:
	for room in room_rects:
		if new_room.grow(2).intersects(room.grow(1)):
			return true
	return false

func _carve_tile(x: int, y: int, tile: TileDefinition = map_data.tile_set.floor):
	for room in rooms:
		if room.bounds.has_point(Vector2i(x,y)):
			return
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
