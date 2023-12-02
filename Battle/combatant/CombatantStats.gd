extends Resource
class_name CombatantStats

signal max_health_changed(value)
signal health_changed(value)
signal shield_changed(value)
signal armor_changed(value)
signal dodges_changed(value)
signal hit
signal dodged
signal shield_broke
signal died

@export var max_health: int : set = set_max_health
@export var base_shield: int
@export var base_armor: int
@export var base_dodges: int
var health: int : set = set_health
var shield: int : set = set_shield
var armor: int : set = set_armor
var dodges: int : set = set_dodges
# Variable is_dead para arreglar habilidades con multiples golpes enviando multiples señales
var is_dead: bool = false

func _init(p_max_health: int = 100, p_base_shield: int = 0, p_base_armor: int = 0, p_base_dodges: int = 0):
	max_health = p_max_health
	base_shield = p_base_shield
	base_armor = p_base_armor
	base_dodges = p_base_dodges
	health = max_health
	shield = base_shield
	armor = base_armor
	dodges = base_dodges
	
	
func setup():
	health = max_health

func start_battle():
	shield = base_shield
	armor = base_armor
	dodges = base_dodges
	
func start_turn():
	pass

func end_turn():
	pass

func end_battle():
	shield = 0
	armor = 0
	dodges = 0
	
func set_max_health(value):
	max_health = max(1, value)
	max_health_changed.emit(max_health)

func set_health(value):
	health = clamp(value, 0, max_health)
	health_changed.emit(health)
	if health == 0 and not is_dead:
		is_dead = true
		died.emit()


func set_shield(value):
	shield = max(0,value)
	shield_changed.emit(shield)

func set_armor(value):
	armor = value
	armor_changed.emit(armor)
	
func set_dodges(value):
	dodges = value
	dodges_changed.emit(dodges)

func take_damage(amount: int, ignore_shield = false, ignore_armor = false, ignore_dodges = false):
	var eff_shield = 0 if ignore_shield else shield
	var eff_armor = 0 if ignore_armor else armor
	var eff_dodges = 0 if ignore_dodges else dodges
	if eff_dodges > 0:
		dodges -= 1
		dodged.emit()
	elif eff_shield > 0:
		var damage_remainder = amount - eff_armor - eff_shield
		var armor_remainder = max(0, eff_armor - eff_shield)
		shield -= max(0, amount - eff_armor)
		if shield == 0:
			shield_broke.emit()
		if damage_remainder > 0:
			health -= max(0, damage_remainder - armor_remainder)
			hit.emit()
	else:
		health -= max(0, amount - eff_armor)
		hit.emit()

func take_percent_damage(percent: float, ignore_shield = false, ignore_armor = false, ignore_dodges = false):
	var amount: int = floori(percent * health)
	take_damage(amount, ignore_shield, ignore_armor, ignore_dodges)
