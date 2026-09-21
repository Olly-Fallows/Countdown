extends HBoxContainer
class_name AbilityBar

func _ready() -> void:
	setup()
	
func setup() -> void:
	if not GameData.player:
		setup.call_deferred()
	GameData.player.abilities.abilities_changed.connect(populate)
	populate()
		
func populate() -> void:
	for c in get_children():
		remove_child(c)
	for a in range(GameData.player.abilities.abilities.size()):
		add_child(AbilityBox.new(" "+str(a+1)+":", GameData.player.abilities.abilities[a].icon, GameData.player.abilities.abilities[a].colour))
		add_child(VSeparator.new())
	add_child(AbilityBox.new(" I:", GameData.player.controller.inspect.icon, GameData.player.controller.inspect.colour))
	#GameData.turn_taken.connect(update)

func _process(_delta: float) -> void:
	if not GameData.player:
		return
	for c in get_children():
		if c is AbilityBox:
			for a in GameData.player.abilities.abilities:
				if a.icon == c.icon:
					if a.can_use() and GameData.player.combat.mana >= a.mana_cost:
						c.modulate = c.colour
					else:
						c.modulate = Color.DIM_GRAY
