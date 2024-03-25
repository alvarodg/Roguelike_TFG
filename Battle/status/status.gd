extends Resource
class_name Status

@export var ui_data: StatusUIData = StatusUIData.new()
@export var description: String = ""

@export var modifiers: Array[Modifier]
@export var condition_triggers: Array[ConditionTrigger]

func attach_to(user):
	for mod in modifiers:
		mod.apply_to(user)
	for trigger in condition_triggers:
		trigger.apply_to(user)
	user.ended_battle.connect(_on_battle_ended)

func connect_to(user):
	for trigger in condition_triggers:
		trigger.apply_to(user)
	user.ended_battle.connect(_on_battle_ended)

func setup():
	for trigger in condition_triggers:
		trigger.setup()
	
func get_description() -> String:
	if description == "":
		var desc = ""
		for mod in modifiers:
			if desc != "": desc += "\n"
			desc += mod.get_description()
		for trigger in condition_triggers:
			if desc != "": desc += "\n"
			desc += trigger.get_description()
		return desc
	else: 
		return description

func _on_battle_ended():
	print("ending")
