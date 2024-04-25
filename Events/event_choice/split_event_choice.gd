extends EventChoice
class_name SplitEventChoice

# Decisión de evento con una tirada de moneda asociada, que puede dar lugar a dos secuencias
# según su resultado. Posiblemente extender a múltiples categorías de resultados con múltiples secuencias.

@export var alt_sequence: ChoiceSequence
@export var coinbox_data: ChoiceCoinBoxData
@onready var top_container = %TopContainer

var coinbox: ChoiceCoinBox

func _ready():
# Button y Label estan declarados únicos y tienen el mismo nombre que en la clase base,
# por lo que no es necesario asignarlos de nuevo en esta clase. (¿Hacerlo de todas formas?)
#	button = %Button
#	label = %Label
	coinbox = coinbox_data.create_instance()
	coinbox.setup(player)
	top_container.add_child(coinbox)
	top_container.move_child(coinbox, 0)
	coinbox.hide()
	coinbox.selected.connect(_on_coinbox_selected)
	coinbox.finished.connect(_on_coinbox_finished)
	_update_description(label)
	_check_cost()

func initialize(p_player: Player, data):
	var split_data = data as SplitEventChoiceData
	alt_sequence = split_data.alt_sequence
	coinbox_data = split_data.coinbox_data
	super.initialize(p_player, split_data)

func _on_Button_pressed():
	coinbox.show()

func _on_coinbox_selected():
	selected.emit(self)
	if cost is Cost:
		cost.pay(player)
	
func _on_coinbox_finished(result: bool):
	var chosen_sequence = sequence if result else alt_sequence
	if sequence != null:
		await _apply_sequence(chosen_sequence)
	if final:
		finished.emit()
	else:
		returned.emit()
