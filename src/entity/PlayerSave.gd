extends Node

@warning_ignore("unused_signal")
signal save

var health: int = -1
var max_health: int = -1
var mana: int = -1
var max_mana: int = -1

var strength: int = -1
var arcane: int = -1

var inventory: Inventory = null

var abilities: Array[Ability] = []

var weapon: Item = null
var armour: Item = null

func reset() -> void:
	health = -1
	max_health = -1
	mana = -1
	max_mana = -1
	
	strength = -1
	arcane = -1
	
	inventory = null
	
	weapon = null
	armour = null
	
	abilities = []
