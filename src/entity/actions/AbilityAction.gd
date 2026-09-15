extends Action
class_name AbilityAction

var ability: Ability
var grid_pos: Vector2i

func _init(a: Ability, p: Vector2i) -> void:
	ability = a
	grid_pos = p

func perform(entity: Entity) -> bool:
	if not ability.can_use():
		Log.log(ability.name + " is still on cooldown")
		return false
	if entity.combat.mana < ability.mana_cost:
		Log.log(entity.name() + " doesn't have enough mana")
		return false
	if ability.perform(entity, grid_pos):
		entity.combat.spend_mana(ability.mana_cost)
		return true
	return false
