extends Control

signal delete_choice_made(value)
signal stash_choice_made(value)

@onready var continue_button = %ContinueButton
@onready var main_menu_panel = %MainMenuPanel
@onready var seed_menu = %SeedMenu
@onready var seed_edit = %SeedEdit
@onready var start_seeded_button = %StartSeededButton
@onready var credits_panel = %CreditsPanel
@onready var delete_save_menu = %DeleteSaveMenu
@onready var outdated_save_info = %OutdatedSaveInfo


# Called when the node enters the scene tree for the first time.
func _ready():
	seed_menu.hide()
	credits_panel.hide()
	outdated_save_info.hide()
	delete_save_menu.hide()
	continue_button.disabled = true
	start_seeded_button.disabled = true
	if RunData.save_exists():
		if RunData.is_save_compatible():
			continue_button.disabled = false
		else:
			outdated_save_info.show()
			if await stash_choice_made:
				RunData.stash_save()

func _on_NewRunButton_pressed():
	if RunData.save_exists() and RunData.is_save_compatible():
		delete_save_menu.show()
		if await delete_choice_made:
			_new_with_random_seed()
	else:
		_new_with_random_seed()

func _new_with_random_seed():
	RunData.run_seed = randi_range(0,1000000)
	print(RunData.run_seed)
	EventBus.new_run_selected.emit()
	queue_free()

func _on_ContinueButton_pressed():
	EventBus.continue_run_selected.emit()
	queue_free()



func _on_NewSeededRunButton_pressed():
	if RunData.save_exists() and RunData.is_save_compatible():
		delete_save_menu.show()
		if await delete_choice_made:
			seed_menu.show()
	else:
		seed_menu.show()


func _on_SeedEdit_text_changed(new_text):
	var regex = RegEx.new()
	regex.compile("^\\d+$")
	if regex.search(new_text):
		RunData.run_seed = int(new_text)
		start_seeded_button.disabled = false
	else:
		start_seeded_button.disabled = true

func _on_CancelSeededButton_pressed():
	seed_menu.hide()


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


func _on_DeleteYesButton_pressed():
	delete_save_menu.hide()
	delete_choice_made.emit(true)
	

func _on_DeleteNoButton_pressed():
	delete_save_menu.hide()
	delete_choice_made.emit(false)


func _on_StashYesButton_pressed():
	outdated_save_info.hide()
	stash_choice_made.emit(true)


func _on_StashNoButton_pressed():
	get_tree().quit()
