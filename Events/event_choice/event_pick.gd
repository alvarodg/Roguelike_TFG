extends EventScene
class_name EventPick

@onready var choice_container = %ChoiceContainer
@onready var player_stats_ui = $PlayerStatsUI
@onready var narrative_label = %NarrativeLabel
@onready var event_picture = %EventPicture

var narrative: String
var image: Texture2D
var choices: Array[EventChoiceData]

# Called when the node enters the scene tree for the first time.
func _ready():
	player_stats_ui.setup(player)
	for choice in choices:
		var scene: EventChoice = choice.create_instance(player)
		choice_container.add_child(scene)
		scene.events_about_to_begin.connect(_on_choice_begins)
		scene.finished.connect(_on_choice_finished)
		scene.returned.connect(_on_choice_returned)
		scene.selected.connect(_on_choice_selected)
	narrative_label.text = narrative
	event_picture.texture = image

func initialize(data: EventPickData):
	narrative = data.narrative
	choices = data.choices
	image = data.image

func _on_choice_begins():
	hide()

func _on_choice_finished():
	finish()

func _on_choice_returned():
	show()

func _on_choice_selected(choice: EventChoice):
	for c in choice_container.get_children():
		if c is EventChoice and c != choice:
			c.disable()

