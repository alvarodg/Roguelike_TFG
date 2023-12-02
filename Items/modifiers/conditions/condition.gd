# Posible reimplementación del sistema de Triggers más extensible, lo mismo no merece la pena.
extends Resource
class_name Condition

signal met

var active: bool = true
var user

func connect_to(p_user):
	user = p_user

func _on_met(_param = null):
	met.emit()
