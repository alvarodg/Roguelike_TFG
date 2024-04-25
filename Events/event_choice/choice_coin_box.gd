extends Control
class_name ChoiceCoinBox

signal selected
signal finished(result)
# Para posible futura implementación que deje el tratamiento de los resultados fuera de la clase
#signal coins_flipped(heads_count, coin_amount)



@onready var coin_container = %CoinContainer
@onready var flip_button = %FlipButton
@onready var cancel_button = %CancelButton
@onready var stop_button = %StopButton
@onready var target_label = %TargetLabel

var default_coin: CoinData = load("res://Battle/coin_ui/resources/default_coin.tres")

enum Operator {MORE, MORE_OR_EQUAL, EQUAL, LESS_OR_EQUAL, LESS}

@export var coin_amount: int = 1
@export var target_heads: int = 1
@export var operator: Operator = Operator.MORE_OR_EQUAL

@export var player: Player

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(coin_amount):
		var coin: Coin = default_coin.create_coin_instance()
		coin.make_untouchable()
		coin_container.add_child(coin)
	_generate_target_text()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func initialize(data: ChoiceCoinBoxData):
	coin_amount = data.coin_amount
	target_heads = data.target_heads
	operator = data.operator

func setup(p_player: Player):
	player = p_player

func _generate_target_text():
	target_label.text = "Target: "
	match operator:
		Operator.MORE:
			target_label.text += ">" + str(target_heads) + " Heads"
		Operator.MORE_OR_EQUAL:
			target_label.text += str(target_heads) + " or more Heads"
		Operator.EQUAL:
			target_label.text += "Exactly" + str(target_heads) + " Heads"
		Operator.LESS_OR_EQUAL:
			target_label.text += str(coin_amount-target_heads) + " or more Tails"
		Operator.LESS:
			target_label.text += ">" + str(coin_amount-target_heads) + " Tails"

func _use_comparison_operator(op: Operator, param1, param2):
	match op:
		Operator.MORE:
			return param1 > param2
		Operator.MORE_OR_EQUAL:
			return param1 >= param2
		Operator.EQUAL:
			return param1 == param2
		Operator.LESS_OR_EQUAL:
			return param1 <= param2
		Operator.LESS:
			return param1 < param2

func _on_FlipButton_pressed():
	selected.emit()
	for coin in coin_container.get_children():
		if coin is Coin:
			coin.start_spinning()
	flip_button.hide()
	cancel_button.hide()
	stop_button.show()


func _on_StopButton_pressed():
	var heads_count: int = 0
	for coin in coin_container.get_children():
		if coin is Coin:
			if player.logic_flip(coin):
				heads_count += 1
			coin.stop_spinning()
			# TEMPORAL. Probablemente cambiar el temporizador por algo más elegante.
			await get_tree().create_timer(0.32).timeout
	var result = _use_comparison_operator(operator, heads_count, target_heads)
	stop_button.disabled = true
	finished.emit(result)
