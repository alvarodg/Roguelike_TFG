extends Resource
# Secuencia de eventos resultado de seleccionar una opción
class_name ChoiceSequence

# Lista de modificadores a aplicar antes de ejecutar los eventos
@export var pre_modifiers: Array[Modifier]
# Lista de modificadores a aplicar despúes de ejecutar los eventos
@export var post_modifiers: Array[Modifier]
# Lista de eventos a ejecutar
@export var events: Array[EventData]
# Valor para la interfaz, si es "false" indica que se debe mostrar el resultado 
# de la secuencia antes de seleccionarla, si es "true" no se debe mostrar.
@export var secret: bool = false
# Narrativa a mostrar antes de ejecutar los eventos y modificadores (opcional)
@export var pre_narrative: NarrativeSceneData
# Narrativa a mostrar después de ejecutar los eventos y modificadores (opcional)
@export var post_narrative: NarrativeSceneData
# Lista de eventos que se añadirán a la colección de eventos de la partida
# al completar la secuencia, lo que permitirá que aparezcan aleatoriamente
@export var event_unlocks: Array[EventData]
# Si es "true", el evento que llame a esta secuencia se eliminará de la 
# colección de eventos de la partida
@export var make_unique: bool = false

# Genera y devuelve la descripción de la secuencia
func get_description() -> String:
	var desc: String = ""
	for mod in pre_modifiers:
		desc += mod.get_description() + "\n"
	for event in events:
		if not event.secret:
			desc += event.get_description() + "\n"
	for mod in post_modifiers:
		desc += mod.get_description() + "\n"
	return desc.strip_edges()
