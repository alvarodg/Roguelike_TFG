extends EventScene
## Un evento de decisión está compuesto de una serie de opciones con diversas
## consecuencias de entre las que tendrá que seleccionar el jugador
class_name EventPick

# Objetos genéricos para la interfaz de la escena
@onready var choice_container = %ChoiceContainer
@onready var narrative_label = %NarrativeLabel
@onready var event_picture = %EventPicture
@onready var event_name_label = %EventNameLabel
# Objeto de interfaz que muestra las estadísticas del jugador
@onready var player_stats_ui = $PlayerStatsUI

## Nombre del evento
var event_name: String
## Narrativa asociada al evento
var narrative: String
## Imagen representativa del evento
var image: Texture2D
## Lista de opciones entra las que podrá elegir el jugador
var choices: Array[EventChoiceData]

# Called when the node enters the scene tree for the first time.
func _ready():
	# Llama a la función ready de la superclase
	super._ready()
	# Asigna el jugador a su interfaz de estadísticas
	player_stats_ui.setup(player)
	# Para cada opción
	for choice in choices:
		# Crea su escena a partir del jugador 
		var scene: EventChoice = choice.create_instance(player)
		# Añade esta al contenedor de opciones de la interfaz
		choice_container.add_child(scene)
		# Conecta sus señales
		scene.events_about_to_begin.connect(_on_choice_begins)
		scene.finished.connect(_on_choice_finished)
		scene.returned.connect(_on_choice_returned)
		scene.selected.connect(_on_choice_selected)
		scene.pre_selected.connect(_on_choice_pre_selected)
	# Asigna las variables cosméticas del evento a la interfaz
	narrative_label.text = narrative
	event_picture.texture = image
	event_name_label.text = event_name.to_upper()

## Inicializa la escena a partir de su clase de datos y el jugador
func initialize(p_player: Player, data: EventPickData):
	super.initialize(p_player, data)
	narrative = data.narrative
	choices = data.choices
	image = data.image
	event_name = data.name

## Las siguientes funciones fueron diseñadas para reaccionar a las señales de
## EventChoice:

## Cuando empieza a ejecutarse una opción, oculta la interfaz de decisión
func _on_choice_begins():
	hide()

## Cuando una opción indica que el evento ha finalizado, envía la señal
func _on_choice_finished():
	finish()

## Cuando una opción indica que vuelve a la interfaz de decisión,
## vuelve a mostrarla
func _on_choice_returned():
	show()

## Cuando una opción se ha seleccionado, desactiva todas las demás opciones
func _on_choice_selected(choice: EventChoice):
	for c in choice_container.get_children():
		if c is EventChoice and c != choice:
			c.disable()

## Cuando una opción se ha pre-seleccionado, reinicia la interfaz de todas las
## escenas con tiradas asociadas
func _on_choice_pre_selected(choice: EventChoice):
	for c in choice_container.get_children():
		if c is SplitEventChoice and c != choice:
			await c.hide_coinbox()
