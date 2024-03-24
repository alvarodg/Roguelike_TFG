extends Node
## Clase principalmente para guardar las señales que tanto los enemigos como el jugador emiten.
class_name Combatant

signal started_battle
signal pre_started_turn
signal started_turn
signal turn_finished
signal ended_battle
signal died
signal equipment_changed(value)
signal started_waiting
signal finished_waiting
signal stats_changed(value)

var battle_position: Vector2
var last_contact: Combatant

# Subclases deberán tener los siguientes parámetros:
# stats: CombatantStats o subclase
# ui_data: CombatantUIData o subclase

# Usar métodos pseudo-virtuales?
#func get_stats():
#	pass
#
#func get_ui_data():
#	pass

func wait(time: float):
	if time > 0:
		started_waiting.emit()
		await get_tree().create_timer(time).timeout
	finished_waiting.emit()

func get_body_position():
	pass
