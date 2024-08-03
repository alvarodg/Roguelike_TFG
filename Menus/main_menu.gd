extends Control

@onready var continue_button = %ContinueButton
@onready var main_menu_panel = %MainMenuPanel
@onready var seed_panel = %SeedPanel
@onready var seed_edit = %SeedEdit
@onready var start_seeded_button = %StartSeededButton
@onready var credits_panel = %CreditsPanel

# Called when the node enters the scene tree for the first time.
func _ready():
	credits_panel.hide()
	continue_button.disabled = true
	start_seeded_button.disabled = true
	if RunData.save_exists():
		if RunData.is_save_compatible():
			continue_button.disabled = false
		else:
			print("Partida guardada no compatible.")
			RunData.stash_save()

func _on_NewRunButton_pressed():
	RunData.run_seed = randi_range(0,1000000)
	print(RunData.run_seed)
	EventBus.new_run_selected.emit()
	queue_free()

func _on_ContinueButton_pressed():
	EventBus.continue_run_selected.emit()
	queue_free()



func _on_NewSeededRunButton_pressed():
	seed_panel.show()


func _on_SeedEdit_text_changed(new_text):
	var regex = RegEx.new()
	regex.compile("^\\d+$")
	if regex.search(new_text):
		RunData.run_seed = int(new_text)
		start_seeded_button.disabled = false
	else:
		start_seeded_button.disabled = true

func _on_CancelSeededButton_pressed():
	seed_panel.hide()


func _on_StartSeededButton_pressed():
	EventBus.new_run_selected.emit()
	queue_free()


func _on_QuitButton_pressed():
	get_tree().quit()


func _on_CreditsButton_pressed():
	credits_panel.show()

func _on_CreditsPanel_gui_input(event):
	if event is InputEventMouseButton:
		credits_panel.hide()
