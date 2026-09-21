extends Generator
class_name SingleRoom

@export
var entities: Array[EntityDefinition] = [
]

@export
var room: RoomPreset = preload("uid://vfp628ues6sq")

func generate(_s: Vector2i, player: Entity) -> MapData:
	var size: Vector2i = room.get_size()
	map_data = MapData.new(size+Vector2i(2,2))
	
	var room_bounds: Room = Room.new(Rect2(Vector2i(1,1), room.get_size()))
	
	_carve_room(room_bounds.bounds)
	room.place(map_data, room_bounds)
	
	var spawn_pos: Array[Vector2i] = room.spawn_positions(room_bounds)
	
	for a in range(entities.size()):
		if entities[a].player_controller:
			player.grid_pos = spawn_pos[a]
			map_data.entities.append(player)
		else:
			map_data.entities.append(Entity.new(spawn_pos[a], entities[a]))
	
	return map_data

func _carve_tile(x: int, y: int, tile: TileDefinition = map_data.tile_set.floor):
	map_data.get_tile_xy(x,y).set_definition(tile)

func _carve_room(rect: Rect2i) -> void:
	for x in range(rect.position.x, rect.end.x):
		for y in range(rect.position.y, rect.end.y):
			map_data.get_tile_xy(x,y).set_definition(map_data.tile_set.floor)
