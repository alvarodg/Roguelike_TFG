extends Resource
class_name Status

@export var ui_data: StatusUIData = StatusUIData.new()
@export var description: String = ""

@export var modifiers: Array[Modifier]
@export var cause_and_effects: CauseAndEffects

func attach_to(user):
	for mod in modifiers:
		mod.apply_to(user)
	cause_and_effects.attach_to(user)
	user.ended_battle.connect(_on_battle_ended)

func connect_to(user):
	cause_and_effects.attach_to(user)
	user.ended_battle.connect(_on_battle_ended)

func setup():
	cause_and_effects.setup()
	
func get_description() -> String:
	if description == "":
		var desc = ""
		for mod in modifiers:
			if desc != "": desc += "\n"
			desc += mod.get_description()
		desc += cause_and_effects.get_description()
		return desc
	else: 
		return description

func _on_battle_ended():
	print("ending")
