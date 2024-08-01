extends Resource
## Clase de estadísticas base para combatientes
class_name CombatantStats

## Señales de cambio de cada estadística
signal max_health_changed(old_value, new_value)
signal health_changed(old_value, new_value, max_value)
signal strength_changed(old_value, new_value)
signal shield_changed(old_value, new_value)
signal armor_changed(old_value, new_value)
signal dodges_changed(old_value, new_value)
## Señal enviada cuando recibe un golpe que reduce su vida
signal hit
## Señal enviada cuando esquiva un golpe
signal dodged
## Señal enviada cuando se rompe su escudo
signal shield_broke
## Señal enviada cuando recibe un golpe, ya sea al escudo o a la vida
signal made_contact
## Señal enviada antes de morir cuando su vida llega a 0
signal about_to_die
## Señal enviada después de morir cuando su vida llega a 0
signal died

## Cantidad máxima de vida del combatiente
@export var max_health: int = 90 : set = set_max_health
## Fuerza base al principio de cada combate
@export var base_strength: int = 0
## Escudo base al principio de cada combate
@export var base_shield: int = 0
## Armadura base al principio de cada combate
@export var base_armor: int = 0
## Esquivas base al principio de cada combate
@export var base_dodges: int = 0
## Fuerza, amplificador de daño
var strength: int : set = set_strength
## Vida, pierde cuando llega a 0
var health: int : set = set_health
## Escudo, vida adicional temporal
var shield: int : set = set_shield
## Armadura, atenudador de daño
var armor: int : set = set_armor
## Esquivas, permiten ignorar golpes 
var dodges: int : set = set_dodges
## Variable is_dead para asegurarse de que las habilidades con multiples golpes
## no envien multiples señales
var is_dead: bool = false

## Constructor
func _init(p_max_health: int = 100, p_base_strength: int = 0, p_base_shield: int = 0, p_base_armor: int = 0, p_base_dodges: int = 0):
	max_health = p_max_health
	base_strength = p_base_strength
	base_shield = p_base_shield
	base_armor = p_base_armor
	base_dodges = p_base_dodges
	health = max_health
	strength = base_strength
	shield = base_shield
	armor = base_armor
	dodges = base_dodges
	
## Inicializa a valores base
func setup():
	health = max_health
	strength = base_strength
	shield = base_shield
	armor = base_armor
	dodges = base_dodges
	is_dead = false
	
## Inicializa los valores a su estado de principio de combate
func start_battle():
	strength = base_strength
	shield = base_shield
	armor = base_armor
	dodges = base_dodges
	is_dead = false
	
## Modifica los valores a su estado de principio de turno
func start_turn():
	pass

## Modifica los valores a su estado de final de turno
func end_turn():
	pass

## Modifica los valores a su estado de final de combate
func end_battle():
	shield = 0
	armor = 0
	dodges = 0
	
## Setter de max_health
func set_max_health(value):
	var old = max_health
	max_health = max(1, value)
	if health > 0:
		health = min(health, max_health)
	max_health_changed.emit(old, max_health)

## Setter de health
func set_health(value):
	var old = health
	health = clamp(value, 0, max_health)
	health_changed.emit(old, health, max_health)
	if health == 0 and not is_dead:
		is_dead = true
		died.emit()

## Setter de strength
func set_strength(value):
	var old = strength
	strength = value
	strength_changed.emit(old, strength)
	
## Setter de shield
func set_shield(value):
	var old = shield
	shield = max(0,value)
	shield_changed.emit(old, shield)

## Setter de armor
func set_armor(value):
	var old = armor
	armor = value
	armor_changed.emit(old, armor)
	
## Setter de dodges
func set_dodges(value):
	var old = dodges
	dodges = value
	dodges_changed.emit(old, dodges)

## Función que recibe cierta cantidad de daño, aplicando o no escudo, armadura
## y esquivas dependiendo de sus parámetros
func take_damage(amount: int, ignore_shield = false, ignore_armor = false, 
				 ignore_dodges = false, shield_factor: float = 1.0):
	# Valores efectivos a 0 si se ignoran, si no a su verdadero valor
	var eff_shield = 0 if ignore_shield else shield
	# Aplica el factor de eficacia al escudo
	if eff_shield > 0:
		eff_shield = ceil(eff_shield/shield_factor)
	var eff_armor = 0 if ignore_armor else armor
	var eff_dodges = 0 if ignore_dodges else dodges
	# Si hay esquivas efectivas, se gasta una e indica que ha esquivado
	if eff_dodges > 0:
		dodges -= 1
		dodged.emit()
	# Si hay escudo efectivo,recibe el daño atenuado por la armadura efectiva
	# Si el daño recibido sobrepasa la cantidad de escudo, indica que este 
	# se ha roto y resta a la vida la cantidad de daño restante
	elif eff_shield > 0:
		made_contact.emit()
		var damage_remainder = amount - eff_armor - eff_shield
		var armor_remainder = max(0, eff_armor - eff_shield)
		print(amount*shield_factor)
		shield -= max(0, floor((amount - eff_armor)*shield_factor))
		if shield == 0:
			shield_broke.emit()
		if damage_remainder > 0:
			health -= max(0, damage_remainder - armor_remainder)
			hit.emit(max(0, damage_remainder - armor_remainder))
	# Sin no hay escudo ni esquivas efectivas, recibe el daño directamente
	# en la vida, atenuado por la armadura efectiva
	else:
		made_contact.emit()
		health -= max(0, amount - eff_armor)
		hit.emit(max(0, amount - eff_armor))

## Recibe un cierto porcentaje de su vida como daño, pudiendo ignorar defensas
func take_percent_damage(percent: float, ignore_shield = false, ignore_armor = false, ignore_dodges = false):
	var amount: int = floori(percent * health)
	take_damage(amount, ignore_shield, ignore_armor, ignore_dodges)
