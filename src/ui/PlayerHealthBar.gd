extends ProgressBar
class_name PlayerHealthBar

func _ready() -> void:
	show_percentage = false
	setup()
	
func setup() -> void:
	if not GameData.player:
		setup.call_deferred()
	GameData.player.combat.hurt.connect(update)
	GameData.player.combat.heal.connect(update)
	update(0)
	
func update(_amount: int) -> void:
	max_value = GameData.player.combat.max_health
	value = GameData.player.combat.health
