extends Status
class_name StackableStatus

enum Rate {LINEAR, EXPONENTIAL}

@export var stackable_modifiers: Array[StatModifier]
@export var base_magnitude: int
@export var magnitude_factor: float
@export var rate: Rate = Rate.LINEAR
@export var max_stacks: int
var current_stacks = 1 : set = set_current_stacks

func attach_to(user):
	if self in user.status_list:
		current_stacks += 1
	else:
		cause_and_effects.triggered.connect(_on_effect_triggered)
		_update_modifiers()
		super.attach_to(user)

func _on_effect_triggered():
	current_stacks -= 1
	if current_stacks < 1:
		pass

func _apply_factor(amount: float):
	match rate:
		Rate.LINEAR:
			return base_magnitude + (amount-1)*magnitude_factor
		Rate.EXPONENTIAL:
			# PENDIENTE
			return base_magnitude * pow(magnitude_factor, amount-1)
			
func _update_modifiers():
	for modifier in stackable_modifiers:
		modifier.magnitude = _apply_factor(current_stacks)
		
		
func set_current_stacks(amount: int):
	current_stacks = amount
	_update_modifiers()
