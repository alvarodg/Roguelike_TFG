extends EventChoice
class_name SplitEventChoice

# Decisión de evento con una tirada de moneda asociada, que puede dar lugar a dos secuencias
# según su resultado. Posiblemente extender a múltiples categorías de resultados con múltiples secuencias.

@export var alt_sequence: ChoiceSequence
@export var coinbox_data: ChoiceCoinBoxData
@onready var top_container = %TopContainer

var coinbox: ChoiceCoinBox
var coinbox_hidden_position: Vector2
var coinbox_visible_position: Vector2


func _ready():
# Button y Label estan declarados únicos y tienen el mismo nombre que en la clase base,
# por lo que no es necesario asignarlos de nuevo en esta clase. (¿Hacerlo de todas formas?)
#	button = %Button
#	label = %Label
	coinbox = coinbox_data.create_instance()
	coinbox.setup(player)
#	top_container.add_child(coinbox)
#	top_container.move_child(coinbox, 0)
	button.add_child(coinbox)
#	coinbox.show_behind_parent = true
	coinbox.hide()
	coinbox.selected.connect(_on_coinbox_selected)
	coinbox.finished.connect(_on_coinbox_finished)
	coinbox.canceled.connect(hide_coinbox)
	_update_description(label)
	_check_cost()

func initialize(p_player: Player, data):
	var split_data = data as SplitEventChoiceData
	alt_sequence = split_data.alt_sequence
	coinbox_data = split_data.coinbox_data
	super.initialize(p_player, split_data)

func _on_Button_pressed():
	coinbox_hidden_position = coinbox.global_position
	coinbox_visible_position = coinbox.global_position - Vector2(size.x, 0)
	await _display_coinbox()

func _display_coinbox():
	if not coinbox.visible:
		pre_selected.emit(self)
		button.disabled = true
#		coinbox.z_index -= 1
		coinbox.disable_input()
		coinbox.global_position = coinbox_hidden_position
		coinbox.show()
		var tween = get_tree().create_tween()
		tween.tween_property(coinbox,"global_position", coinbox_visible_position, 0.5)
		await tween.finished
		coinbox.enable_input()
#		coinbox.z_index += 1
		
func hide_coinbox():
	if coinbox.visible:
		coinbox.disable_input()
		var tween = get_tree().create_tween()
		coinbox.global_position = coinbox_visible_position
		tween.tween_property(coinbox,"global_position", coinbox_hidden_position, 0.5)
		await tween.finished
		coinbox.hide()
		button.disabled = false

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
