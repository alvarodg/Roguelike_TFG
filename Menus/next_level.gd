# Esta implementación no hace nada especial al terminar el nivel.
extends EventScene

@export var target_level: int = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	# No puede enviar la señal con la implementación actual, ¿cambiar await por connect?
	pass



func _on_NextButton_pressed():
	EventBus.level_finished.emit()
	finish()
