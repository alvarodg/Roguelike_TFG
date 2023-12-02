# Posible reimplementación del sistema de Triggers más extensible, lo mismo no merece la pena.
extends Condition
class_name StateCondition

signal state_changed(state_ref, value)
