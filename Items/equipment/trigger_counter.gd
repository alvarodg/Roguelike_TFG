extends Control

@onready var count_label = %CountLabel

signal out_of_triggers

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setup(trigger: ConditionTrigger):
	trigger.triggers_changed.connect(_on_triggers_changed)
	display_trigger_count(trigger.amount, trigger.triggers_remaining)

func display_trigger_count(amount: int, remaining: int):
	print(remaining)
	if amount < 0:
		count_label.text = ""
		hide()
	else:
		count_label.text = str(remaining)
		if remaining == 0: out_of_triggers.emit()
		show()


func _on_triggers_changed(amount: int, remaining: int):
	display_trigger_count(amount, remaining)

