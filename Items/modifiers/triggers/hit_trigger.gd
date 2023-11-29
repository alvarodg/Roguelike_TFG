extends Trigger
class_name HitTrigger

func apply_to(p_player: Player):
	p_player.stats.hit.connect(_on_triggered)
	super.apply_to(p_player)

func get_description():
	var desc: String = "When player is hit:\n"
	return desc + super.get_description()
