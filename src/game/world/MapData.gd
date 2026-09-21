extends RefCounted
class_name MapData

signal entity_added(entity: Entity)
signal item_added(item: ItemSprite)

const entity_pathfinding_weight = 10.0

const tile_set: Dictionary[String, TileDefinition] = {
	"floor" : preload("uid://br53225heb43i"),
	"wall": preload("uid://b15cqladnv5ur"),
	"stairs": preload("uid://dwk3ec4e4vwqo"),
	"doom_floor": preload("uid://cbfbpjvgfxaqh"),
	"doom_wall": preload("uid://b1hrb5u8nebpd"),
	"cage": preload("uid://dhr8kq2p702nm"),
	"crystal": preload("uid://guudsvwuyy53"),
	"broken_crystal": preload("uid://brhheuuiue5o0"),
	"door": preload("uid://bvfogviy3og5j")
}

var size: Vector2i

var tiles: Array[Tile]
var entities: Array[Entity]
var items: Array[ItemSprite]

var pathfinder: AStarGrid2D

func _init(s: Vector2i) -> void:
	size = s
	_setup_tiles()

func setup_pathfinding() -> void:
	pathfinder = AStarGrid2D.new()
	pathfinder.region = Rect2i(0,0,size.x,size.y)
	pathfinder.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	pathfinder.update()
	for x in size.x:
		for y in size.y:
			pathfinder.set_point_solid(Vector2i(x,y), not get_tile_xy(x,y).is_traversable())
	for entity in entities:
		if not entity.is_traversable():
			register_blocking_entity(entity)
			
func register_blocking_entity(entity: Entity) -> void:
	pathfinder.set_point_weight_scale(entity.grid_pos, entity_pathfinding_weight)

func unregister_blocking_entity(entity: Entity) -> void:
	pathfinder.set_point_weight_scale(entity.grid_pos, 0)
	
func _setup_tiles() -> void:
	tiles = []
	for x in size.x:
		for y in size.y:
			var tile = Tile.new(Vector2i(x,y), tile_set.wall)
			tiles.append(tile)

func get_item_xy(x: int, y: int) -> ItemSprite:
	return get_item(Vector2i(x,y))

func get_item(pos: Vector2i) -> ItemSprite:
	for item in items:
		if item.grid_pos == pos:
			return item
	return null

func get_entity_xy(x: int, y: int) -> Entity:
	return get_entity(Vector2i(x,y))

func get_entity(pos: Vector2i) -> Entity:
	for entity in entities:
		if entity.grid_pos == pos:
			if not entity.is_traversable():
				return entity
	return null

func get_tile_xy(x: int, y: int) -> Tile:
	return get_tile(Vector2i(x,y))
	
func get_tile(grid_pos: Vector2i) -> Tile:
	var index = grid_to_index(grid_pos)
	if index != -1:
		return tiles[index]
	return null

func grid_to_index(pos: Vector2i) -> int:
	if is_out_of_bounds(pos):
		return -1
	return pos.x * size.y + pos.y

func add_entity(entity: Entity) -> void:
	entity_added.emit(entity)
	entities.append(entity)
	
func add_item(item: ItemSprite) -> void:
	item_added.emit(item)
	items.append(item)

func is_out_of_bounds(pos: Vector2i) -> bool:
	if pos.x < 0:
		return true
	elif pos.x >= size.x:
		return true
	elif pos.y < 0:
		return true
	elif pos.y >= size.y:
		return true
	return false

func is_traversable(pos: Vector2i) -> bool:
	if not get_tile(pos).is_traversable():
		return false
	for entity in entities:
		if entity.grid_pos == pos:
			if not entity.is_traversable():
				return false
	return true

func cleanup() -> void:
	for tile in tiles:
		tile.queue_free()
	for entity in entities:
		entity.queue_free()
