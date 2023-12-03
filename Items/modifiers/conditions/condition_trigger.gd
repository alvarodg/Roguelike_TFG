extends Resource
class_name ConditionTrigger

signal state_ok(value)

var turn_manager = preload("res://Battle/resources/TurnManager.tres")
@export var state_conditions: Array[StateCondition]
@export var event_condition: EventCondition
@export var modifiers: Array[Modifier]
@export var amount: int = -1
@export var reset_per_turn: bool = true
var player: Player
var triggers_remaining: int
var current_state: Array[bool]


func _init(p_state_conditions: Array[StateCondition] = [], 
			p_event_condition: EventCondition = null, p_modifiers: Array[Modifier] = [], 
			p_amount: int = -1, p_reset_per_turn: bool = true):
	state_conditions = p_state_conditions
	event_condition = p_event_condition
	modifiers = p_modifiers
	amount = p_amount
	reset_per_turn = p_reset_per_turn
	triggers_remaining = amount
	
func setup():
	triggers_remaining = amount
	var temp: Array[bool] = []
	temp.resize(state_conditions.size())
	temp.fill(false)
	current_state = temp
	
	
func apply_to(p_player: Player):
	player = p_player
	for state in state_conditions:
		state.connect_to(p_player)
		state.state_changed.connect(_on_state_changed)
	if event_condition is EventCondition:
		event_condition.connect_to(p_player)
		event_condition.met.connect(_on_triggered)
	else:
		state_ok.connect(_on_triggered)
	_connect_signals(player)
	
func _on_triggered(_param = null):
	if _can_trigger():
		for mod in modifiers:
			mod.apply_to(player)
		triggers_remaining -= 1

func _can_trigger():
	return triggers_remaining != 0 and current_state.all(func(x): return x==true)

func _connect_signals(p_player: Player):
	if reset_per_turn and not turn_manager.player_turn_started.is_connected(_on_player_turn_started):
		turn_manager.player_turn_started.connect(_on_player_turn_started)
	if amount > 0:
		p_player.started_battle.connect(_on_player_battle_started)
		

func _on_state_changed(state_ref, value):
	current_state[state_conditions.find(state_ref)] = value
	if current_state.all(func(x): return x==true):
		state_ok.emit(true)

func _on_player_turn_started():
	triggers_remaining = amount

func _on_player_battle_started():
	triggers_remaining = amount

func get_description():
	var desc: String = ""
	var cond_text: String = ""
	var mod_text: String = ""
#	var start: String = "If:" if event_condition is EventCondition else "When:"
	for state in state_conditions:
		if cond_text == "": cond_text += "If:" if event_condition is EventCondition else "When:"
#		if cond_text != "": cond_text += "\n\t"
		cond_text += "\n* " + state.get_description()
	if event_condition is EventCondition:
		cond_text += "\nWhen " + event_condition.get_description() + ":"
	else:
		cond_text += "\nDo:"
	desc += cond_text
	for mod in modifiers:
#		if mod_text == "": mod_text += "Do:"
		if mod_text != "": mod_text += "\n"
		mod_text += "* " + mod.get_description()
	desc += "\n" + mod_text
	if amount != -1:
		var plural: String = "" if amount==1 else "s"
		var frequency: String = "turn" if reset_per_turn else "battle"
		desc += "\n(%d time%s per %s)" % [amount, plural, frequency]
	return desc.strip_edges()
