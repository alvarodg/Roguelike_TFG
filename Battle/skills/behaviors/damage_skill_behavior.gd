extends SkillBehavior
class_name DamageSkillBehavior


@export var damage = 0
@export var to_self: bool = false
@export var ignore_shield: bool = false
@export var ignore_armor: bool = false
@export var ignore_dodges: bool = false


func use(user, target, _coins):
	if to_self:
		user.stats.take_damage(damage, ignore_shield, ignore_armor, ignore_dodges)
	else:
		target.stats.take_damage(damage, ignore_shield, ignore_armor, ignore_dodges)

func get_description() -> String:
	var description: String = ""
	var damage_type: String = ""
	var damage_description: String = ""
	# Describe con un tipo al daño si existe uno de acuerdo con sus características.
	if ignore_armor and ignore_dodges and ignore_shield:
		damage_type = " True"
	elif ignore_armor and ignore_shield:
		damage_type = " Piercing"
	elif ignore_dodges and not ignore_armor and not ignore_shield:
		damage_type = " Certain Hit"
	# Indica sus características concretas en el resto de casos.
	elif ignore_armor or ignore_dodges or ignore_shield:
		var armor_text = "Armor" if ignore_armor else ""
		var dodges_text = "Dodges" if ignore_dodges else ""
		var shield_text = "Shield" if ignore_shield else ""
		damage_description = " (Ignores %s %s %s)" % [shield_text, armor_text, dodges_text]
	if to_self:
		description = "%s%s Damage%s to self." % [damage, damage_type, damage_description]
	else:
		description = "%s%s Damage%s to target." % [damage, damage_type, damage_description]
	return description
