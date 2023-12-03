# Posible reimplementación del sistema de Triggers más extensible, lo mismo no merece la pena.
extends Condition
class_name EventCondition

signal met

func _on_met():
	met.emit()
