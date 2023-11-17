extends CombatantStats
class_name PlayerStats

@export var coin_count: int = 5
@export var base_luck: float = 1.0


func _init(p_max_health = 100, p_base_shield = 0, p_base_armor = 0, p_base_dodges = 0, p_coin_count: int = 5, p_base_luck: float = 1.0):
	super(p_max_health,p_base_shield,p_base_armor,p_base_dodges)
	coin_count = p_coin_count
	base_luck = p_base_luck

func to_save_dict() -> Dictionary:
	return {
		"max_health" : max_health,
		"base_shield" : base_shield,
		"base_armor" : base_armor,
		"base_dodges" : base_dodges,
		"coin_count" : coin_count,
		"base_luck" : base_luck,
		"health" : health,
	}
	
func load_save_dict(dict: Dictionary):
	max_health = dict["max_health"]
	base_shield = dict["base_shield"]
	base_armor = dict["base_armor"]
	base_dodges = dict["base_dodges"]
	coin_count = dict["coin_count"]
	base_luck = dict["base_luck"]
	health = dict["health"]
