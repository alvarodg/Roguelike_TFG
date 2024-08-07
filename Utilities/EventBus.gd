extends Node

signal event_finished
signal level_finished
signal new_run_selected
signal continue_run_selected
signal level_generation_completed
signal started_dragging(object)
signal stopped_dragging(object)
signal was_selected(object)
signal released_selected(object)
signal equipment_equipped(equipment)
signal coin_inserted(slot,coin)
signal looking_for_coin(facing)
signal found_coin(coin)
signal about_to_drop_coins
signal behavior_finished(behavior)
signal player_ui_finished_operation
signal battle_started
signal battle_finished

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


