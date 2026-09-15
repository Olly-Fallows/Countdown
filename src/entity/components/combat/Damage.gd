extends RefCounted
class_name Damage

var amount: int = 1
enum Type {
	NORMAL,
	ARCANE,
	FIRE,
	DOOM
}
var type: Type

func _init(a: int, t: Type) -> void:
	amount = max(1, a)
	type = t
