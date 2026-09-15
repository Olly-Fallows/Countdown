extends ProgressBar
class_name PlayerManaBar

func _ready() -> void:
	show_percentage = false
	setup()
	
func setup() -> void:
	if not GameData.player:
		setup.call_deferred()
	GameData.player.combat.mana_changed.connect(update)
	update()
	
func update() -> void:
	max_value = GameData.player.combat.max_mana
	value = GameData.player.combat.mana
