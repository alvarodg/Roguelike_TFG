extends Resource
class_name CauseAndEffects

@export var cause: CausalityTrigger
@export var effects: Array[Modifier]
var user

func attach_to(p_user):
	user = p_user
	cause.apply_to(user)
	cause.met.connect(_on_cause)
	
func setup():
	cause.setup()
	
func _on_cause():
	for effect in effects:
		effect.apply_to(user)

func get_description():
	var desc = ""
	desc += cause.get_description() + "\nDo:"
	for effect in effects:
		desc += "\n" + effect.get_description()
