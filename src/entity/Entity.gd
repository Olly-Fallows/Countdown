extends Sprite2D
class_name Entity

signal moved

var _definition: EntityDefinition

var movement_tween: Tween
var grid_pos: Vector2i:
	set(value):
		grid_pos = value
		if is_inside_tree():
			movement_tween = get_tree().create_tween()
			movement_tween.tween_property(self, "global_position", Grid.grid_to_world(value), 0.1)
			movement_tween.tween_callback(moved.emit)
		else:
			global_position = Grid.grid_to_world(value)

var controller: Controller = null

var combat: Combat
var abilities: AbilityTracker

var effects: Array[EntityEffect] = []
var inventory: Inventory

func _init(pos: Vector2i, entity_definition: EntityDefinition) -> void:
	grid_pos = pos
	_definition = entity_definition
	texture = _definition.icon
	modulate = _definition.colour
	
	if _definition.camera_follow:
		var cam = Camera2D.new()
		add_child(cam)
	
	if _definition.player_controller:
		if controller:
			controller.queue_free()
		controller = PlayerController.new()
		add_child(controller)
	elif _definition.enemy_controller:
		if controller:
			controller.queue_free()
		controller = EnemyController.new()
		add_child(controller)
		
	combat = Combat.new(_definition)
	add_child(combat)
	combat.dead.connect(cleanup)
	
	abilities = AbilityTracker.new()
	for ability in _definition.abilities:
		abilities.abilities.append(ability.duplicate())
	
	if is_player():
		if PlayerSave.inventory:
			inventory = PlayerSave.inventory
		else:
			inventory = _definition.inventory.duplicate(true)
		PlayerSave.save.connect(save_inventory)
	else:
		inventory = _definition.inventory.duplicate(true)
	
	GameData.turn_taken.connect(effect_tick)

func do_action() -> bool:
	if not controller:
		return true
	var action = controller.get_action()
	if action:
		@warning_ignore("redundant_await")
		return await action.perform(self)
	return false

func apply_effect(effect: EntityEffect) -> void:
	effect.apply(self)
	effects.append(effect)

func effect_tick() -> void:
	var to_remove: Array[EntityEffect] = []
	for effect in effects:
		effect.tick(self)
		effect.ttl -= 1
		if effect.ttl <= 0:
			effect.remove(self)
			to_remove.append(effect)
	for effect in to_remove:
		effects.erase(effect)

func move(move_offset: Vector2i) -> bool:
	if GameData.map_data.is_traversable(grid_pos + move_offset):
		if move_offset == Vector2i(1,0):
			flip_h = false
		if move_offset == Vector2i(-1,0):
			flip_h = true
		GameData.map_data.unregister_blocking_entity(self)
		grid_pos += move_offset
		GameData.map_data.register_blocking_entity(self)
		var item: ItemSprite = GameData.map_data.get_item(grid_pos)
		if item:
			if inventory.add_item(item.item):
				Log.log(name() + " picked up " + item.item.name)
				item.queue_free()
		await moved
		GameData.map_data.get_tile(grid_pos).apply_effects(self)
		return true
	return false

func bump(bump_offset: Vector2i) -> void:
	if bump_offset == Vector2i(1,0):
		flip_h = false
	if bump_offset == Vector2i(-1,0):
		flip_h = true
	var bump_tween: Tween = get_tree().create_tween()
	bump_tween.tween_property(self, "global_position", global_position+(Vector2(bump_offset)*(Vector2(Grid.tile_size)/2)), 0.05)
	await bump_tween.finished
	bump_tween = get_tree().create_tween()
	bump_tween.tween_property(self, "global_position", Grid.grid_to_world(grid_pos), 0.075)
	await bump_tween.finished
	
func save_inventory() -> void:
	PlayerSave.inventory = inventory.duplicate(true)
	
func is_traversable() -> bool:
	return _definition.is_passable

func is_player() -> bool:
	return _definition.player_controller

func colour() -> Color:
	return _definition.colour

func name() -> String:
	return _definition.entity_name

func cleanup() -> void:
	Log.log(name() + " [u][i]" + _definition.death_verb + "[/i][/u]")
	GameData.map_data.unregister_blocking_entity(self)
	GameData.map_data.entities.erase(self)
	if inventory.items.size() > 0:
		GameData.map_data.add_item(ItemSprite.new(inventory.items.pick_random(), grid_pos))
	queue_free()
