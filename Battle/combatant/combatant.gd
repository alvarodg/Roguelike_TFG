extends Node
## Clase principalmente para guardar las señales que tanto los enemigos como el jugador emiten.
class_name Combatant

signal started_battle
signal started_turn
signal turn_finished
signal died
signal equipment_changed(value)

# Subclases deberán tener los siguientes parámetros:
# stats: CombatantStats o subclase
# ui_data: CombatantUIData o subclase

# Usar métodos pseudo-virtuales?
#func get_stats():
#	pass
#
#func get_ui_data():
#	pass
