extends Node
## Clase principalmente para guardar las señales que tanto los enemigos como el jugador emiten.
class_name Combatant

var DAMAGE_NUMBER = load("res://Battle/animations/damage_number.tscn")

signal started_battle
signal pre_started_turn
signal started_turn
signal turn_finished
signal ended_battle
signal about_to_die
signal died
signal equipment_changed(value)
signal started_waiting
signal finished_waiting
signal stats_changed(value)

var battle_position: Vector2
var last_contact: Combatant
var status_list: Array[Status]
var equipment_list: Array[Equipment]

# Subclases deberán tener los siguientes parámetros:
# A MODIFICAR
# stats: CombatantStats o subclase
# ui_data: CombatantUIData o subclase

# Método pseudo-virtual para acceder a las estadísticas
# Devuelve CombatantStats, no indicado explícitamente porque la 
# covarianza en tipos de retorno no está implementada en Godot 4.1
func get_stats(): 
	return CombatantStats.new()

# Método pseudo-virtual para acceder a los datos para la interfaz
# Devuelve CombatantUIData, no indicado explícitamente porque la 
# covarianza en tipos de retorno no está implementada en Godot 4.1
func get_ui_data():
	return CombatantUIData.new()


func take_damage(_amount: int, _ignore_shield = false, _ignore_armor = false, _ignore_dodges = false, _shield_factor: float = 1.0):
	pass

func wait(time: float):
	if time > 0:
		started_waiting.emit()
		await get_tree().create_timer(time).timeout
	finished_waiting.emit()

func get_body_position():
	pass
