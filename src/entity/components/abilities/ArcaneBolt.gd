extends Ability
class_name ArcaneBolt

func _init() -> void:
	super._init(8, 6, 1)
	name = "Arcane Bolt"
	icon.atlas = load("res://assets/TileSet.png")
	icon.region = Rect2i(0, 16*9, 16, 16)
	colour = Color.PURPLE
	
func perform(caster: Entity, grid_pos: Vector2i) -> bool:
	var tile: Tile = GameData.map_data.get_tile(grid_pos)
	if tile:
		if tile.is_type(GameData.map_data.tile_set.crystal):
			tile.set_definition(preload("res://resources/tiles/BrokenCrystal.tres"))
			var offsets = [Vector2i(1,0),Vector2i(-1,0),Vector2i(0,1),Vector2i(0,-1)]
			for offset in offsets:
				var t = GameData.map_data.get_tile(grid_pos+offset)
				if t.is_traversable():
					t.set_definition(GameData.map_data.tile_set.doom_floor)
					t.effects[0].spread_delay = 1
					t.effects[0].spread_cooldown = 0
			for t in GameData.map_data.tiles:
				if t.is_type(GameData.map_data.tile_set.cage):
					t.set_definition(GameData.map_data.tile_set.floor)
			Log.log("[color=#5f00cf]Oh no! the creeping doom has been released![/color]")
			GameData.map_data.setup_pathfinding()
			Sfx.play_zap()
			return true
	var target: Entity = GameData.map_data.get_entity(grid_pos)
	if target:
		Log.log(target.name() + " got shot with an arcane bolt")
		current_cooldown = ability_cooldown
		target.combat.take_damage(caster.combat.get_damage(6, Damage.Type.ARCANE))
		Sfx.play_zap()
		return true
	return false
