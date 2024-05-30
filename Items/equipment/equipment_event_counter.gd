extends Control

@onready var count_label = %CountLabel

signal out_of_triggers

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setup(trigger: ConditionTrigger):
	if trigger.event_condition is EventCondition:
		trigger.event_condition.remaining_changed.connect(_on_event_changed)
#	trigger.triggers_changed.connect(_on_triggers_changed)
#	display_triggers(trigger.amount, trigger.triggers_remaining)
	display_event_count(trigger.event_condition.amount, trigger.event_condition.remaining)

func display_triggers(amount: int, remaining: int):
	if amount < 0:
		count_label.text = ""
		hide()
	else:
		count_label.text = str(remaining)
		if remaining == 0: out_of_triggers.emit()
		show()

func display_event_count(amount: int, remaining: int):
	if amount <= 1:
		count_label.text = ""
		hide()
	else:
		count_label.text = str(remaining)
		if remaining == 0: out_of_triggers.emit()
		show()

func _on_triggers_changed(amount: int, remaining: int):
	display_triggers(amount, remaining)

func _on_event_changed(amount: int, remaining: int):
	display_event_count(amount, remaining)
