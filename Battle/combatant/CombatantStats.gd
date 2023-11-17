extends Resource
class_name CombatantStats

signal max_health_changed(value)
signal health_changed(value)
signal shield_changed(value)
signal armor_changed(value)
signal dodges_changed(value)
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

func take_damage(amount):
	# Se podría dividir más para poder ignorar partes de la fórmula selectivamente
	if dodges > 0:
		dodges -= 1
		dodged.emit()
	elif shield > 0:
		var damage_remainder = amount - armor - shield
		var armor_remainder = max(0, armor - shield)
		shield -= max(0, amount - armor)
		if shield == 0:
			shield_broke.emit()
		if damage_remainder > 0:
			health -= max(0, damage_remainder - armor_remainder)
	else:
		health -= max(0, amount - armor)
