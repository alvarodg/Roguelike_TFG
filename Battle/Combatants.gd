extends Resource
class_name Combatants

var player: Player = null
var enemy: Enemy = null

func get_opponent(user: Combatant) -> Combatant:
	if user == player:
		return enemy
	elif user == enemy:
		return player
	else:
		return null
