extends Node
class_name AbilityTracker

signal abilities_changed

var abilities: Array[Ability] = [
	Clairvoyance.new(),
	ArcaneBolt.new()
]

func add_ability(ability: Ability) -> void:
	abilities.append(ability)
	abilities_changed.emit()

func remove_ability(ability: Ability) -> void:
	abilities.erase(ability)
	abilities_changed.emit()
