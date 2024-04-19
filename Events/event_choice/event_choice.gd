extends Control
class_name EventChoice

signal events_about_to_begin
signal finished

@onready var button = $Button
@onready var label = $Button/Label

var description: String
var explicit: bool = true
var cost: Cost
var sequence: ChoiceSequence
var player: Player
var final: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	_update_description()
	_check_cost()
	#TEMPORAL
#	_check_cost()
#	player.stats_changed.connect(_on_Player_Stats_changed)
	

func initialize(p_player: Player, data: EventChoiceData):
	player = p_player
	player.stats_changed.connect(_on_Player_Stats_changed)
	sequence = data.sequence
	explicit = data.explicit
	description = data.description
	cost = data.cost
	final = data.final

func setup(p_player: Player):
	player = p_player
	_update_description()
	_check_cost()
	player.stats_changed.connect(_on_Player_Stats_changed)

func _on_Player_Stats_changed(_stats):
	_check_cost()

func _on_Button_pressed():
	if cost is Cost:
		cost.pay(player)
	if sequence != null:
		for mod in sequence.pre_modifiers:
			mod.apply_to(player)
		if sequence.events.size() > 0: 
			events_about_to_begin.emit()
			for event in sequence.events:
				var scene: EventScene = event.instantiate_scene(player)
				get_tree().root.add_child(scene)
				await scene.finished
		for mod in sequence.post_modifiers:
			mod.apply_to(player)
	if final:
		finished.emit()
	
func _update_description():
	if explicit or description == "":
		var desc: String
		if cost != null:
			desc += cost.get_description() + "\n"
		if sequence is ChoiceSequence:
			for mod in sequence.pre_modifiers:
				desc += mod.get_description() + "\n"
			for event in sequence.events:
				desc += event.get_description() + "\n"
			for mod in sequence.post_modifiers:
				desc += mod.get_description() + "\n"
		if description == "":
			label.text = desc
		elif desc == "":
			label.text = description
		else:		
			label.text =  description + "\n(" + desc.strip_edges() + ")" 
	else:
		label.text = description

func _check_cost():
	if cost != null:
		if cost.can_pay(player):
			button.disabled = false
		else:
			button.disabled = true
