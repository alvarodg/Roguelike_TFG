extends Control
class_name EventChoice

signal events_about_to_begin

@onready var button = $Button
@onready var label = $Button/Label

@export_multiline var description: String
@export var explicit: bool = true
@export var sequence: ChoiceSequence
@export var player: Player


# Called when the node enters the scene tree for the first time.
func _ready():
	_update_description()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func initialize(p_sequence: ChoiceSequence):
	sequence = p_sequence
	_update_description()

func setup(p_player: Player):
	player = p_player

func _on_Button_pressed():
	for mod in sequence.pre_modifiers:
		mod.apply_to(player)
	if sequence.events.size() > 0: 
		events_about_to_begin.emit()
		for event in sequence.events:
			var scene: EventScene = event.instantiate_scene()
			add_child(scene)
			await scene.finished
	for mod in sequence.post_modifiers:
		mod.apply_to(player)

func _update_description():
	if explicit or description == "":
		var desc: String
		for mod in sequence.pre_modifiers:
			desc += mod.get_description() + "\n"
		for event in sequence.events:
			desc += event.get_description() + "\n"
		for mod in sequence.post_modifiers:
			desc += mod.get_description() + "\n"
		label.text = desc if description == "" else description + "\n\n(" + desc.strip_edges() + ")" 
	else:
		label.text = description
