# Posible reimplementación del sistema de Triggers más extensible, lo mismo no merece la pena.
extends Resource
class_name Condition

var turn_manager = preload("res://Battle/resources/TurnManager.tres")
var combatants = load("res://Battle/resources/Combatants.tres")
var active: bool = true
var user

func connect_to(p_user):
	user = p_user
