extends Equipment
class_name PlayerEquipment

@export var coin_count: int
@export var base_luck: float
#
## Solo puede sumar o restar números planos a las estadísticas
#func attach_to(player: Player):
#	var stats: PlayerStats = player.stats
#	stats.coin_count += coin_count
#	stats.base_luck += base_luck
#	stats.max_health += max_health
#	stats.health += health
#	stats.base_armor += base_armor
#	stats.base_shield += base_shield
#	stats.base_dodges += base_dodges
#
#func release_from(player: Player):
#	var stats: PlayerStats = player.stats
#	stats.coin_count -= coin_count
#	stats.base_luck -= base_luck
#	stats.max_health -= max_health
#	stats.health -= health
#	stats.base_armor -= base_armor
#	stats.base_shield -= base_shield
#	stats.base_dodges -= base_dodges
#
#func get_description():
#	if description == "":
#		var desc: String = ""
#		if coin_count != 0:
#			desc += "%+d Coin Count.\n" % coin_count
#		if base_luck != 0:
#			desc += "%+.2f Base Luck.\n" % base_luck
#		desc += super.get_description()
#		return desc
#	else:
#		return description
