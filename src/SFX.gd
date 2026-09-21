extends Node

func play_hurt() -> void:
	var sfx: AudioStreamPlayer = AudioStreamPlayer.new()
	sfx.stream = preload("uid://c45lyqawfmbx1")
	sfx.bus = "sfx"
	add_child(sfx)
	sfx.play()
	sfx.finished.connect(sfx.queue_free)

func play_dead() -> void:
	var sfx: AudioStreamPlayer = AudioStreamPlayer.new()
	sfx.stream = preload("uid://63sucsfg4re5")
	sfx.bus = "sfx"
	add_child(sfx)
	sfx.play()
	sfx.finished.connect(sfx.queue_free)

func play_equip() -> void:
	var sfx: AudioStreamPlayer = AudioStreamPlayer.new()
	sfx.stream = preload("uid://d3sfmqaajcko6")
	sfx.bus = "sfx"
	add_child(sfx)
	sfx.play()
	sfx.finished.connect(sfx.queue_free)

func play_pickup() -> void:
	var sfx: AudioStreamPlayer = AudioStreamPlayer.new()
	sfx.stream = preload("uid://bnpna423jjrfy")
	sfx.bus = "sfx"
	add_child(sfx)
	sfx.play()
	sfx.finished.connect(sfx.queue_free)

func play_potion() -> void:
	var sfx: AudioStreamPlayer = AudioStreamPlayer.new()
	sfx.stream = preload("uid://btgh5pfyj2urx")
	sfx.bus = "sfx"
	add_child(sfx)
	sfx.play()
	sfx.finished.connect(sfx.queue_free)

func play_zap() -> void:
	var sfx: AudioStreamPlayer = AudioStreamPlayer.new()
	sfx.stream = preload("uid://dy3sxrd33ndrg")
	sfx.bus = "sfx"
	add_child(sfx)
	sfx.play()
	sfx.finished.connect(sfx.queue_free)

func play_decend() -> void:
	var sfx: AudioStreamPlayer = AudioStreamPlayer.new()
	sfx.stream = preload("uid://sdj2ty1h5ac3")
	sfx.bus = "sfx"
	add_child(sfx)
	sfx.play()
	sfx.finished.connect(sfx.queue_free)
