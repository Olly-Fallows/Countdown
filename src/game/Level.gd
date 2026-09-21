extends Node2D
class_name Level

const player_definition: EntityDefinition = preload("uid://sg6v0fof4mfx")

@export
var size: Vector2i = Vector2i(50,50)
@export
var generator: Generator

var tiles: Node2D
var entities: Node2D
var items: Node2D

var taking_turn: bool = false

@export
var bgm: AudioStream = preload("uid://csdurjhlicu78")

func _ready() -> void:
	# Setup map
	GameData.player = Entity.new(Vector2i(5,5), player_definition)
	
	GameData.map_data = generator.generate(size, GameData.player)
	GameData.map_data.setup_pathfinding()
	
	_place_tiles()
	items = Node2D.new()
	add_child(items)
	_place_entities()
	
	GameData.fov = FieldOfView.new()
	add_child(GameData.fov)
	GameData.fov.update_fov(GameData.map_data, GameData.player.grid_pos, 8)
	
	GameData.map_data.entity_added.connect(entities.add_child)
	GameData.map_data.item_added.connect(items.add_child)
	
	Bgm.play_track(bgm)
	
func _physics_process(_delta: float) -> void:
	take_turn()
	
func take_turn() -> void:
	if taking_turn:
		return
	taking_turn = true
	if GameData.player:
		if await GameData.player.do_action():
			for entity in GameData.map_data.entities:
				if entity != GameData.player:
					await entity.do_action()
			for tile in GameData.map_data.tiles:
				tile.do_passives()
			if GameData.player:
				GameData.fov.update_fov(GameData.map_data, GameData.player.grid_pos, 8)
			GameData.turn_taken.emit()
	taking_turn = false
	
func _place_tiles() -> void:
	if not tiles:
		tiles = Node2D.new()
		tiles.name = "tiles"
		add_child(tiles)
	
	for tile in GameData.map_data.tiles:
		tiles.add_child(tile)

func _place_entities() -> void:
	if not entities:
		entities = Node2D.new()
		entities.name = "entities"
		add_child(entities)
	
	for entity in GameData.map_data.entities:
		entities.add_child(entity)
