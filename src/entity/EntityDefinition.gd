extends Resource
class_name EntityDefinition

@export
var entity_name: String
@export
var death_verb: String = "died"

@export_category("Visuals")
@export
var icon: AtlasTexture
@export
var colour: Color = Color.WHITE
@export
var camera_follow: bool = false

@export_category("Controller")
@export
var player_controller: bool = false
@export
var enemy_controller: bool = false
@export
var wander_controller: bool = false
@export
var dungeon_princess_controller: bool = false
@export
var princess_controller: bool = false
@export
var boss_controller: bool = false

@export_category("Mechanics")
@export
var is_passable: bool = false
@export
var is_transparent: bool = true

@export_category("Stats")
@export
var max_health: int = 10
@export
var regen: int = 0
@export
var regen_delay: int = 0

@export
var max_mana: int = 10
@export
var mana_regen: int = 0
@export
var mana_regen_delay: int = 0

@export
var strength: int = 10
@export
var arcane: int = 10

@export
var abilities: Array[Ability] = []
@export
var inventory: Inventory = Inventory.new()
