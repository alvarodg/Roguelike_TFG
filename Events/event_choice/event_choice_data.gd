extends Resource
# Clase que contiene los datos de una opción de un evento de decisión
class_name EventChoiceData

# Referencia a la escena de la opción
var scene: PackedScene = load("res://Events/event_choice/event_choice.tscn")

# Descripción de la opción
@export_multiline var description: String
@export var explicit: bool = false
# Coste (opcional) que se debe pagar para poder seleccionar la opción
@export var cost: Cost
# Secuencia de la opción
@export var sequence: ChoiceSequence = ChoiceSequence.new()
# Un valor "true" en esta variable hace que el evento termine una vez 
# seleccionada esta opción, "false" volverá al evento de decisión
@export var final: bool = true
@export var secret: bool = false

# Crea y devuelve una instancia de la escena de opción
func create_instance(player: Player):
	var instance = scene.instantiate()
	instance.initialize(player, self)
	return instance
