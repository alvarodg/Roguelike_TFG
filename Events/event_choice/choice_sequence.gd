extends Resource
class_name ChoiceSequence

@export var pre_modifiers: Array[Modifier]
@export var post_modifiers: Array[Modifier]
@export var events: Array[EventData]
@export var secret: bool = false
@export_multiline var pre_narrative: String
@export_multiline var post_narrative: String
@export var event_unlocks: Array[EventData]

func get_description() -> String:
	var desc: String = ""
	for mod in pre_modifiers:
		desc += mod.get_description() + "\n"
	for event in events:
		if not event.secret:
			desc += event.get_description() + "\n"
	for mod in post_modifiers:
		desc += mod.get_description() + "\n"
	return desc.strip_edges()
