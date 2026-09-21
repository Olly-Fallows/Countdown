@abstract
extends Resource
class_name ItemEquips

@export
var abilities: Array[Ability] = []

enum EquipSlot {
	WEAPON,
	ARMOUR
}
@export
var slot: EquipSlot = EquipSlot.WEAPON

@abstract
func equip(entity: Entity) -> void

@abstract
func unequip(entity: Entity) -> void
