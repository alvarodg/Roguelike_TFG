extends Control

@onready var player = $Player
@onready var map = $Map
@onready var text_edit = %TextEdit
@onready var regenerate_button = %RegenerateButton

@export var run_seed: int = -1
var current_seed

# Called when the node enters the scene tree for the first time.
func _ready():
	start_map(run_seed)


func start_map(p_seed):
	var rng = RandomNumberGenerator.new()
	if p_seed != -1:
		rng.seed = p_seed
	else:
		rng.seed = randi_range(0, 1000000)
	current_seed = rng.seed
	RunData.rng = rng
	map.start_game(player, rng)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_RegenerateButton_pressed():
	var regen_seed = -1 if text_edit.text == "" else int(text_edit.text)
	var rng = RandomNumberGenerator.new()
	if regen_seed != -1:
		rng.seed = regen_seed
	else:
		rng.seed = current_seed
	await map.regenerate_levels(rng)


func _on_TextEdit_text_changed():
	var regex = RegEx.new()
	regex.compile("^\\d+$")
	if regex.search(text_edit.text) or text_edit.text == "":
		regenerate_button.disabled = false
	else:
		regenerate_button.disabled = true
