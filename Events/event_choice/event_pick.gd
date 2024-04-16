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
		var scene: EventChoice = choice.initialize_scene(player)
		choice_container.add_child(scene)
		scene.finished.connect(_on_choice_finished)
	narrative_label.text = narrative
	event_picture.texture = image

func initialize(p_player: Player, data: EventPickData):
	player = p_player
	narrative = data.narrative
	choices = data.choices
	image = data.image

func _on_choice_finished():
	finish()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
