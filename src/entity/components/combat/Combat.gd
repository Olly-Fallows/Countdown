extends Node
class_name Combat

signal dead
signal hurt(damage: int)
signal heal(healing: int)

signal mana_changed

var max_health: int = 1
var health: int = max_health

var regen_amount: int
var regen_delay: int
var regen_countdown: int = 0

var max_mana: int = 1
var mana: int = max_mana

var mana_regen_amount: int
var mana_regen_delay: int
var mana_regen_countdown: int = 0

var strength: int
var arcane: int

var armour: int = 0

func _init(definition: EntityDefinition) -> void:
	max_health = definition.max_health
	health = definition.max_health
	
	regen_amount = definition.regen
	regen_delay = definition.regen_delay
	regen_countdown = regen_delay
	
	max_mana = definition.max_mana
	mana = definition.max_mana
	
	mana_regen_amount = definition.mana_regen
	mana_regen_delay = definition.mana_regen_delay
	mana_regen_countdown = mana_regen_delay
	
	strength = definition.strength
	arcane = definition.arcane
	
	GameData.turn_taken.connect(regen)
	GameData.turn_taken.connect(mana_regen)
	
	if definition.player_controller:
		load_save()
		PlayerSave.save.connect(save)

func increase_health(h: int) -> void:
	max_health += h
	health += h
	heal.emit(h)
	
func increase_mana(m: int) -> void:
	max_mana += m
	mana += m
	mana_changed.emit()
	
func decrease_health(h: int) -> void:
	max_health -= h
	health = min(health, max_health)
	heal.emit(h)
	
func decrease_mana(m: int) -> void:
	max_mana -= m
	mana = min(mana, max_mana)
	mana_changed.emit()

func take_damage(dmg: Damage) -> int:
	if dmg.amount > 0:
		regen_countdown = regen_delay
		var amount = max(1,dmg.amount-armour)
		health -= amount
		if health <= 0:
			dead.emit()
		else:
			Log.log((get_parent() as Entity).name() + " took " + str(amount) + " damage")
			hurt.emit(amount)
		return amount
	return 0

func do_heal(healing: int) -> void:
	if healing <= 0:
		return
	health = min(max_health, health + healing)
	heal.emit(healing)

func get_damage(count: int, type: Damage.Type = Damage.Type.NORMAL) -> Damage:
	@warning_ignore_start("integer_division")
	if type == Damage.Type.NORMAL:
		return Damage.new(randi_range(1,count) + strength_mod(), type)
	else:
		return Damage.new(randi_range(1,count) + arcane_mod(), type)

func regen() -> void:
	if regen_amount > 0:
		if regen_countdown <= 0:
			do_heal(regen_amount)
			regen_countdown = regen_delay
		else:
			regen_countdown -= 1

func spend_mana(amount: int) -> void:
	mana = max(0, mana - amount)
	mana_regen_countdown = mana_regen_delay
	mana_changed.emit()

func gain_mana(amount: int) -> void:
	mana = min(max_mana, mana + amount)
	mana_changed.emit()

func mana_regen() -> void:
	if mana_regen_amount > 0:
		if mana_regen_countdown <= 0:
			gain_mana(mana_regen_amount)
			mana_regen_countdown = mana_regen_delay
		else:
			mana_regen_countdown -= 1

func load_save() -> void:
	if PlayerSave.health >= 0:
		health = PlayerSave.health
	if PlayerSave.mana >= 0:
		mana = PlayerSave.mana
	if PlayerSave.max_health >= 0:
		max_health = PlayerSave.max_health
	if PlayerSave.max_mana >= 0:
		max_mana = PlayerSave.max_mana
	if PlayerSave.strength >= 0:
		strength = PlayerSave.strength
	if PlayerSave.arcane >= 0:
		arcane = PlayerSave.arcane
	
func save() -> void:
	PlayerSave.health = health
	PlayerSave.mana = mana
	PlayerSave.max_health = max_health
	PlayerSave.max_mana = max_mana
	PlayerSave.strength = strength
	PlayerSave.arcane = arcane
	
func strength_mod() -> int:
	return floor((strength-10)/2)

func arcane_mod() -> int:
	return floor((arcane-10)/2)
