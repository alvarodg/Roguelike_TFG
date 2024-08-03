extends EventScene
class_name NarrativeEvent

## Referencias a elementos de interfaz genéricos
@onready var narrative_label = %NarrativeLabel
@onready var continue_button = %ContinueButton
@onready var narrative_panel = %NarrativePanel
@onready var image_panel = %ImagePanel
@onready var narrative_image = %NarrativeImage
## Referencia al objeto de interfaz de estadísticas de jugador
@onready var player_stats_ui = %PlayerStatsUI

## Lista de cadenas de narrativa, cada una se presentará por separado
var narrative: Array[String]
## Imagen (opcional) que se mostrará junto con la narrativa
var image: Texture2D

# Called when the node enters the scene tree for the first time.
func _ready():
	player_stats_ui.setup(player)
	# Asigna la textura a la imagen si tiene una, si no modifica la interfaz
	if image != null:
		narrative_image.texture = image
	else:
		narrative_panel.custom_minimum_size.x = 560
		image_panel.hide()
	# Usa el primer elemento de la lista como texto de NarrativeLabel si existe
	if narrative.size() > 0:
		narrative_label.text = narrative.pop_front()
	# Actualiza el botón según queden o no más páginas de narrativa 
	if narrative.size() > 0:
		continue_button.text = "NEXT ->"
	else:
		continue_button.text = "CONTINUE ->"

func initialize(p_player: Player, data):
	super.initialize(p_player, data)
	narrative = data.narrative.duplicate()
	image = data.image

#
func _on_ContinueButton_pressed():
	if narrative.size() > 0:
		narrative_label.text = narrative.pop_front()
		if narrative.size() == 0:
			continue_button.text = "CONTINUE ->"
	else:
		finish()
