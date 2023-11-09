extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_NewRunButton_pressed():
	RunData.run_seed = randi_range(0,1000000)
	print(RunData.run_seed)
	EventBus.new_run_selected.emit()
	hide()

func _on_ContinueButton_pressed():
	EventBus.continue_run_selected.emit()
	hide()

