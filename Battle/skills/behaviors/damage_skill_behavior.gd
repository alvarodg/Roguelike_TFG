extends SkillBehavior
## Comportamiento que inflinje cierto daño a un combatiente,
## pudiendo tener propiedades adicionales para ignorar defensas
class_name DamageSkillBehavior

## Daño base del comportamiento
@export var damage = 0
## Objetivo que va a recibir el daño
@export var to_self: bool = false
## Opción para ignorar el escudo del objetivo
@export var ignore_shield: bool = false
## Opción para ignorar la armadura del objetivo
@export var ignore_armor: bool = false
## Opción para ignorar las esquivas del objetivo
@export var ignore_dodges: bool = false
## Factor de daño contra escudo
@export var shield_factor: float = 1.0
@export var animation_scene: PackedScene = load("res://Battle/skills/animations/slash_animation.tscn")

## Carga la animación por defecto de ataque
var slash = load("res://Battle/skills/animations/slash_animation.tscn")

func use(user: Combatant, target: Combatant, _coins):
	var animation = null if animation_scene == null else animation_scene.instantiate()
	# Pasa el daño al objetivo y espera a que finalice la animación
	if to_self:
		user.take_damage(damage, ignore_shield, ignore_armor, ignore_dodges, shield_factor)
		if animation != null:
			user.add_child(animation)
			animation.global_position = user.battle_position
			await animation.finished
	else:
		target.take_damage(user.stats.strength + damage, ignore_shield, ignore_armor, ignore_dodges, shield_factor)
		if animation != null:
			target.add_child(animation)
			animation.global_position = target.battle_position
			await animation.finished
	_finish()


func get_description(stats: CombatantStats = null) -> String:
	var description: String = ""
	var damage_type: String = ""
	var damage_description: String = ""
	var string_damage = str(damage) if stats == null or stats.strength == 0 else "[color=green]"+str(damage+stats.strength)+"[/color]"
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
	if shield_factor != 1.0:
		description += "\n(%sx against Shield)" % [shield_factor]
	return description
