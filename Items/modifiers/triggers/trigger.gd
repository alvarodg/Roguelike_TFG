extends Resource
class_name Trigger

var turn_manager = preload("res://Battle/resources/TurnManager.tres")
@export var amount: int = -1
@export var reset_per_turn: bool = true
var triggers_remaining: int

@export var modifiers: Array[Modifier]
var player: Player

func _init(p_amount: int = -1, p_reset_per_turn: bool = true):
	amount = p_amount
	reset_per_turn = p_reset_per_turn
	triggers_remaining = amount
	
func setup():
	triggers_remaining = amount
	
	
func apply_to(p_player: Player):
	player = p_player
	_connect_signals(player)
	
func _on_triggered(_param = null):
	if _can_trigger():
		for mod in modifiers:
			mod.apply_to(player)
		triggers_remaining -= 1

func _can_trigger():
	return triggers_remaining != 0

func _connect_signals(p_player: Player):
	if reset_per_turn and not turn_manager.player_turn_started.is_connected(_on_player_turn_started):
		turn_manager.player_turn_started.connect(_on_player_turn_started)
	if amount > 0:
		p_player.started_battle.connect(_on_player_battle_started)
		
			
func _on_player_turn_started():
	triggers_remaining = amount

func _on_player_battle_started():
	triggers_remaining = amount

func get_description():
	var desc: String = ""
	for mod in modifiers:
		if desc != "": desc += "\n"
		desc += mod.get_description()
	if amount != -1:
		var plural: String = "" if amount==1 else "s"
		var frequency: String = "turn" if reset_per_turn else "battle"
		desc += "\n(%d time%s per %s)" % [amount, plural, frequency]
	return desc
