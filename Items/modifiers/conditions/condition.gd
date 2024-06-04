extends Resource
class_name Condition

## Acceso al gestor de turnos
var turn_manager = preload("res://Battle/resources/TurnManager.tres")
## Acceso a los combatientes actualmente en batalla
var combatants = load("res://Battle/resources/Combatants.tres")
#var active: bool = true
## Referencia al usuario
var user

## Conecta la condición al usuario (implementar en subclases)
func connect_to(p_user):
	user = p_user
