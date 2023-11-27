extends Resource
class_name Equipment

@export var ui_data: EquipmentUIData = EquipmentUIData.new()
@export var description: String = ""
@export var rarity: int
@export var max_health: int
@export var health: int
@export var base_shield: int
@export var base_armor: int
@export var base_dodges: int

func attach_to(user):
	var stats = user.stats
	stats.max_health += max_health
	stats.health += health
	stats.base_armor += base_armor
	stats.base_shield += base_shield
	stats.base_dodges += base_dodges
	
func release_from(user):
	var stats = user.stats
	stats.max_health -= max_health
	stats.health -= health
	stats.base_armor -= base_armor
	stats.base_shield -= base_shield
	stats.base_dodges -= base_dodges

func get_description() -> String:
	if description == "":
		# Tiene que haber una forma mejor de hacer esto, TEMPORAL
		var desc: String = ""
		if max_health != 0:
			desc += "%s Max Health.\n" % max_health
		if health != 0:
			desc += "%s Health.\n" % health
		if base_shield != 0:
			desc += "%s Base Shield.\n" % base_shield
		if base_armor != 0:
			desc += "%s Base Armor.\n" % base_armor
		if base_dodges != 0:
			desc += "%s Base Dodges." % base_dodges
		return desc
	else:
		return description
