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

var weapon: Item = null
var armour: Item = null

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
	elif _definition.wander_controller:
		if controller:
			controller.queue_free()
		controller = WanderController.new()
		add_child(controller)
	elif _definition.dungeon_princess_controller:
		if controller:
			controller.queue_free()
		controller = DungeonPrincessController.new()
		add_child(controller)
	elif _definition.princess_controller:
		if controller:
			controller.queue_free()
		controller = PrincessController.new()
		add_child(controller)
	elif _definition.boss_controller:
		if controller:
			controller.queue_free()
		controller = BossController.new()
		add_child(controller)
		
	combat = Combat.new(_definition)
	add_child(combat)
	combat.dead.connect(cleanup)
	combat.hurt.connect(hurt_vfx)
	
	abilities = AbilityTracker.new()
	if is_player():
		if PlayerSave.abilities.size() > 0:
			abilities.abilities = PlayerSave.abilities
		else:
			abilities.abilities = []
			for ability in _definition.abilities:
				abilities.abilities.append(ability)
	else:
		abilities.abilities = []
		for ability in _definition.abilities:
			abilities.abilities.append(ability)
	
	if is_player():
		if PlayerSave.inventory:
			inventory = PlayerSave.inventory
		else:
			inventory = _definition.inventory.duplicate(true)
		equip(PlayerSave.weapon)
		equip(PlayerSave.armour)
		PlayerSave.save.connect(save)
		combat.dead.connect(func():
			get_tree().change_scene_to_file(GameData.loose_screen))
	else:
		inventory = _definition.inventory.duplicate(true)
	if controller is PrincessController:
		combat.hurt.connect(func(_d):
			if randf() < 0.5:
				Log.log("[color=#FFC0CB]Ouch![/color]")
				return
			if randf() < 0.5:
				Log.log("[color=#FFC0CB]Go a different way![/color]")
				return
			if randf() < 0.5:
				Log.log("[color=#FFC0CB]Stop it![/color]")
				return
			Log.log("[color=#FFC0CB]Oooooh[/color]")
			)
		combat.dead.connect(func():
			get_tree().change_scene_to_file(GameData.princess_loose_screen))
	
	GameData.turn_taken.connect(effect_tick)

func do_action() -> bool:
	if not controller:
		return true
	@warning_ignore("redundant_await")
	var action = await controller.get_action()
	if action:
		@warning_ignore("redundant_await")
		return await action.perform(self)
	return false

func apply_effect(effect: EntityEffect) -> void:
	effect.apply(self)
	effects.append(effect)
	modulate = calc_effect_colour()

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
	modulate = calc_effect_colour()

func calc_effect_colour() -> Color:
	var r: int = _definition.colour.r8
	var g: int = _definition.colour.g8
	var b: int = _definition.colour.b8
	for effect in effects:
		#c = c.blend(effect.colour)
		r += effect.colour.r8
		g += effect.colour.g8
		b += effect.colour.b8
	r /= (effects.size()+1)
	g /= (effects.size()+1)
	b /= (effects.size()+1)
	return Color.from_rgba8(r, g, b, 255)

func move(move_offset: Vector2i) -> bool:
	if GameData.map_data.is_traversable(grid_pos + move_offset):
		if move_offset == Vector2i(1,0):
			flip_h = false
		if move_offset == Vector2i(-1,0):
			flip_h = true
		if not is_traversable():
			GameData.map_data.unregister_blocking_entity(self)
		grid_pos += move_offset
		if not is_traversable():
			GameData.map_data.register_blocking_entity(self)
		var item: ItemSprite = GameData.map_data.get_item(grid_pos)
		if item:
			if add_item(item.item):
				Log.log(name() + " picked up " + item.item.name)
				item.queue_free()
		if visible and not controller is PrincessController and not controller is DungeonPrincessController:
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
	if visible:
		await bump_tween.finished
	bump_tween = get_tree().create_tween()
	bump_tween.tween_property(self, "global_position", Grid.grid_to_world(grid_pos), 0.075)
	if visible:
		await bump_tween.finished

func hurt_vfx(_dmg: int) -> void:
	if visible:
		Sfx.play_hurt()
		var vfx: VFX = VFX.new()
		vfx.grid_pos = grid_pos
		vfx.modulate = Color.RED
		vfx.sprite_frames = preload("uid://de2nulrwfjwo7")
		add_child(vfx)

func add_item(item: Item) -> bool:
	if is_player():
		Sfx.play_pickup()
		GameData.items_pickedup += 1
	inventory.items.append(item)
	return true

func remove_item(item: Item) -> void:
	if weapon == item:
		item.equips.unequip(self)
		weapon = null
	if armour == item:
		item.equips.unequip(self)
		armour = null
	inventory.items.erase(item)

func equip(item: Item) -> void:
	if not item:
		(texture as AtlasTexture).region.position.x = 0
		return
	if item.equips:
		if item.equips.slot == ItemEquips.EquipSlot.WEAPON:
			if weapon:
				unequip(weapon)
			weapon = item
			item.equips.equip(self)
			Sfx.play_equip()
			if weapon.name.contains("Sword"):
				(texture as AtlasTexture).region.position.x = 16
			elif weapon.name.contains("Staff"):
				(texture as AtlasTexture).region.position.x = 32
			elif weapon.name.contains("Bow"):
				(texture as AtlasTexture).region.position.x = 48
			else:
				(texture as AtlasTexture).region.position.x = 0
		if item.equips.slot == ItemEquips.EquipSlot.ARMOUR:
			if armour:
				unequip(armour)
			armour = item
			item.equips.equip(self)
			Sfx.play_equip()
		if item.equips.abilities.size() > 0:
			for ability in item.equips.abilities:
				abilities.add_ability(ability)

func unequip(item: Item) -> void:
	if item.equips:
		if item.equips.slot == ItemEquips.EquipSlot.WEAPON:
			if weapon == item:
				weapon.equips.unequip(self)
				weapon = null
				(texture as AtlasTexture).region.position.x = 0
		if item.equips.slot == ItemEquips.EquipSlot.ARMOUR:
			if armour == item:
				armour.equips.unequip(self)
				armour = null
		if item.equips.abilities.size() > 0:
			for ability in item.equips.abilities:
				abilities.remove_ability(ability)

func save() -> void:
	PlayerSave.inventory = inventory.duplicate(false)
	PlayerSave.abilities = abilities.abilities
	PlayerSave.weapon = weapon
	PlayerSave.armour = armour
	
func is_traversable() -> bool:
	return _definition.is_passable

func is_player() -> bool:
	return _definition.player_controller

func is_equiped(item: Item) -> bool:
	if weapon == item:
		return true
	if armour == item:
		return true
	return false

func colour() -> Color:
	return _definition.colour

func name() -> String:
	return _definition.entity_name

func cleanup() -> void:
	if is_player():
		(texture as AtlasTexture).region.position.x = 0
	if visible:
		Sfx.play_dead()
	Log.log(name() + " [u][i]" + _definition.death_verb + "[/i][/u]")
	GameData.map_data.unregister_blocking_entity(self)
	GameData.map_data.entities.erase(self)
	if inventory.items.size() > 0:
		var item = inventory.items.pick_random()
		if item:
			GameData.map_data.add_item(ItemSprite.new(item, grid_pos))
	queue_free()
