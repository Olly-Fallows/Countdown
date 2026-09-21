extends Ability
class_name Clairvoyance

func _init() -> void:
	super._init(0, 0, 2)
	name = "Clairvoyance"
	icon.atlas = load("res://assets/TileSet.png")
	icon.region = Rect2i(16, 16*9, 16, 16)
	colour = Color.CYAN

func perform(caster: Entity, _grid_pos: Vector2i) -> bool:
	var exits: Array[Tile] = []
	for tile in GameData.map_data.tiles:
		if tile.is_exit():
			exits.append(tile)
	if exits.size() <= 0:
		Log.log("[color=#00ffff]" + "There is no escape... [/color]")
		return false
	var options: Array[PackedVector2Array] = []
	for exit in exits:
		options.append(GameData.map_data.pathfinder.get_point_path(caster.grid_pos, exit.grid_pos, true))
	var chosen_option: PackedVector2Array = options[0]
	for option in options:
		if option.size() < chosen_option.size():
			chosen_option = option
	Log.log("[color=#00ffff]" + caster.name() + " sees the way out [/color]")
	caster.apply_effect(ClairvoyanceEffect.new(chosen_option[chosen_option.size()-1], 15 + caster.combat.arcane_mod()))
	return true
