extends Control
class_name EventChoice

signal events_about_to_begin
signal returned
signal finished
signal pre_selected(event_choice)
signal selected(event_choice)

@onready var button = %Button
@onready var label = %Label

var description: String
var explicit: bool = true
var cost: Cost
var sequence: ChoiceSequence
var player: Player
var final: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	_update_description(label)
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
	_update_description(label)
	_check_cost()
	player.stats_changed.connect(_on_Player_Stats_changed)

func disable():
	button.disabled = true

func _on_Player_Stats_changed(_stats):
	_check_cost()

func _on_Button_pressed():
	selected.emit(self)
	if cost is Cost:
		cost.pay(player)
	if sequence != null:
		await _apply_sequence(sequence)
	if final:
		finished.emit()
	else:
		returned.emit()
		
	
func _apply_sequence(seq: ChoiceSequence):
	for mod in seq.pre_modifiers:
		mod.apply_to(player)
	if seq.events.size() > 0: 
		events_about_to_begin.emit()
		await ScreenTransitions.fade_to_black()
		ScreenTransitions.fade_from_black()
		print(seq.events)
		for event in seq.events:
			var scene: EventScene = event.instantiate_scene(player)
			get_tree().root.add_child(scene)
			await scene.finished
			# La transición arregla un problema por casualidad al esperar para que
			# queue_free() se pueda hacer en la escena después de que esta envíe la señal.
			# Si no espera a la transición y se intentan encadenar eventos 
			# que comparten recursos pueden darse errores.
			# Investigar si es posible arreglar esto.
			if not event.secret:
				await ScreenTransitions.fade_to_black()
				ScreenTransitions.fade_from_black()
	for mod in seq.post_modifiers:
		mod.apply_to(player)
	
func _update_description(p_label: Label):
	if explicit or description == "":
		var desc: String = ""
		if cost != null:
			desc += cost.get_description() + "\n"
		if sequence is ChoiceSequence:
			for mod in sequence.pre_modifiers:
				desc += mod.get_description() + "\n"
			for event in sequence.events:
				if not event.secret:
					desc += event.get_description() + "\n"
			for mod in sequence.post_modifiers:
				desc += mod.get_description() + "\n"
		if description == "":
			p_label.text = desc
		elif desc == "":
			p_label.text = description
		else:		
			p_label.text =  description + "\n(" + desc.strip_edges() + ")" 
	else:
		p_label.text = description

func _check_cost():
	if cost != null:
		if cost.can_pay(player):
			button.disabled = false
		else:
			button.disabled = true
