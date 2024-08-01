extends EventData
class_name RandomBattleEventData

@export var possible_battles: Array[BattleEventData]

func _init(p_next_event = null, p_possible_battles: Array[BattleEventData] = []):
	super(p_next_event)
	possible_battles = p_possible_battles

func instantiate_scene(player: Player):
	# TODO: Volver a cambiar la implementación a enemigos y quitar esto, tiene más sentido.
	for battle in possible_battles:
		battle.next_event = next_event
		battle.goes_to_next_level = goes_to_next_level
		battle.is_final_event = is_final_event
	var battle_scene = pick_battle().instantiate_scene(player)
	return battle_scene

func pick_battle():
	# Acceso al singleton para el RNG global
	var chosen: int = RunData.rng.randi_range(0,possible_battles.size()-1)
	return possible_battles[chosen]
