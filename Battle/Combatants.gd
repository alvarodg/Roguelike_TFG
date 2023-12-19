extends Resource
class_name Combatants

@export var player: Player = null
@export var enemy: Enemy = null

func get_opponent(user: Combatant) -> Combatant:
	if user == player:
		return enemy
	elif user == enemy:
		return player
	else:
		return null
