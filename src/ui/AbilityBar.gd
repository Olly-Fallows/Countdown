extends HBoxContainer
class_name AbilityBar

func _ready() -> void:
	setup()
	
func setup() -> void:
	if not GameData.player:
		setup.call_deferred()
	for c in get_children():
		remove_child(c)
	for a in range(GameData.player.abilities.abilities.size()):
		add_child(AbilityBox.new(" "+str(a+1)+":", GameData.player.abilities.abilities[a].icon))
		add_child(VSeparator.new())
	add_child(AbilityBox.new(" I:", GameData.player.controller.inspect.icon))
