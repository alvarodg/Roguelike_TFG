extends StateCondition
class_name HasArmorCondition

@export var target: int = 0
@export var operator: Operator

func connect_to(p_user):
	super.connect_to(p_user)
	assert(p_user.stats is CombatantStats)
	p_user.stats.armor_changed.connect(_check_status)
	
func _check_status(armor):
	state_changed.emit(self, _use_comparison_operator(operator, armor, target))

func get_description():
	return _get_comparison_description(operator, "Armor", target)
