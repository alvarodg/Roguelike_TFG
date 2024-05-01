extends Control
class_name EventChoice

signal events_about_to_begin
signal returned
signal finished
signal pre_selected(event_choice)
signal selected(event_choice)

@onready var button: Button = %Button
@onready var label: Label = %Label
@onready var hover_label: Label = %HoverLabel

var description: String
var explicit: bool = false
var cost: Cost
var sequence: ChoiceSequence
var player: Player
var final: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	_update_description(label)
	_update_hover_description(hover_label)
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
			if not event.secret and seq.events.back() != event:
				await ScreenTransitions.fade_to_black()
				ScreenTransitions.fade_from_black()
	for mod in seq.post_modifiers:
		mod.apply_to(player)
	
func _update_description(p_label: Label):
	var desc: String = ""
	var cost_desc: String = ""
	if cost != null:
		cost_desc = cost.get_description() + "\n"
	if explicit or description == "":
		if sequence is ChoiceSequence:
			pass
#			desc += sequence.get_description() + "\n"
		if description == "":
			p_label.text = cost_desc + desc
		elif desc == "":
			p_label.text = cost_desc + description
		else:		
			p_label.text =  cost_desc + description + "\n(" + desc.strip_edges() + ")" 
	else:
		p_label.text = cost_desc + description

func _update_hover_description(p_label: Label):
	if sequence is ChoiceSequence:
		p_label.text = sequence.get_description()

func _check_cost():
	if cost != null:
		if cost.can_pay(player):
			button.disabled = false
		else:
			button.disabled = true

func _on_Button_mouse_entered():
	if hover_label.text != "":
		hover_label.hide()
		hover_label.global_position = get_viewport().get_mouse_position() - Vector2(hover_label.size.x,0)
		await get_tree().create_timer(0.1).timeout
		hover_label.show()
		hover_label.self_modulate = Color.TRANSPARENT
		var tween = get_tree().create_tween()
		tween.tween_property(hover_label, "self_modulate", Color.WHITE, 0.3)

func _on_Button_mouse_exited():
	if hover_label.text != "":
		var tween = get_tree().create_tween()
		tween.tween_property(hover_label, "self_modulate", Color.TRANSPARENT, 0.1)
		await tween.finished
		hover_label.hide()
