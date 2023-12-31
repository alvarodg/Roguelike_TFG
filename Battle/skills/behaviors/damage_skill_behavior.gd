extends SkillBehavior
class_name DamageSkillBehavior


@export var damage = 0
@export var to_self: bool = false
@export var ignore_shield: bool = false
@export var ignore_armor: bool = false
@export var ignore_dodges: bool = false

var wait_time: float = 0.5
const slash = preload("res://Battle/skills/animations/slash_animation.tscn")

func use(user, target, _coins):
	var animation = slash.instantiate()
	if to_self:
		user.stats.take_damage(damage, ignore_shield, ignore_armor, ignore_dodges)
		# Probablemente mover a otra clase y llamar con señales
		user.add_child(animation)
		animation.global_position = user.battle_position
		user.wait(wait_time)
		await target.finished_waiting
	else:
		target.stats.take_damage(user.stats.strength + damage, ignore_shield, ignore_armor, ignore_dodges)
		target.add_child(animation)
		animation.global_position = target.battle_position
		target.wait(wait_time)
		await target.finished_waiting


func get_description(combatant: Combatant = null) -> String:
	var description: String = ""
	var damage_type: String = ""
	var damage_description: String = ""
	var string_damage = str(damage) if combatant == null or combatant.stats.strength == 0 else "[color=green]"+str(damage+combatant.stats.strength)+"[/color]"
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
		damage_description = "Ignores %s %s %s" % [shield_text, armor_text, dodges_text]
		damage_description = " (%)" % damage_description.strip_edges()
	if to_self:
		description = "%s%s Damage%s to self." % [string_damage, damage_type, damage_description]
	else:
		description = "%s%s Damage%s to target." % [string_damage, damage_type, damage_description]
	return description
