extends Resource
class_name SoundCollection

@export var insert_coin_empty: Array[AudioStream]
@export var insert_coin_full: Array[AudioStream]
@export var full_notif: Array[AudioStream]
@export var regular_hit: Array[AudioStream]
@export var heads: AudioStream
@export var tails: AudioStream
@export var undo: Array[AudioStream]
@export var exploration_bgm: AudioStream
@export var battle_bgm: AudioStream
@export var sync_bgm: bool

func get_insert_coin_empty() -> AudioStream:
	return insert_coin_empty.pick_random()
	
func get_insert_coin_full() -> AudioStream:
	return insert_coin_full.pick_random()
	
func get_full_notif() -> AudioStream:
	return full_notif.pick_random()
	
func get_regular_hit() -> AudioStream:
	return regular_hit.pick_random()

func get_undo() -> AudioStream:
	return undo.pick_random()
