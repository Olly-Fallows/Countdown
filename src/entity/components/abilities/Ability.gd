@abstract
extends Resource
class_name Ability

var name: String = ""
var icon: AtlasTexture = AtlasTexture.new()

var ability_range: int = 1
var ability_cooldown: int = 0
var current_cooldown: int = 0
var need_los: bool = false

var mana_cost: int = 0

func _init(r: int, c: int, m: int) -> void:
	ability_range = r
	ability_cooldown = c
	
	mana_cost = m
	
	GameData.turn_taken.connect(reduce_cooldown)

@abstract
func perform(caster: Entity, grid_pos: Vector2i) -> bool

func can_use() -> bool:
	return current_cooldown <= 0

func reduce_cooldown() -> void:
	current_cooldown -= 1
