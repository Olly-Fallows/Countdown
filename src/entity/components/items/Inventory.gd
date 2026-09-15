extends Resource
class_name Inventory

@export
var items: Array[Item]

func add_item(item: Item) -> bool:
	items.append(item)
	return true

func remove_item(item: Item) -> void:
	items.erase(item)
