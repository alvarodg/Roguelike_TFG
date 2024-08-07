extends TextureButton
class_name Slot

signal coin_inserted(slot, coin)
signal coins_changed(coins_needed, current_coins)
signal was_pressed(slot)

@export var facing: Coin.Facing : set = set_facing
@export var heads_ok: bool = true
@export var tails_ok: bool = true
@export var texture_any: Texture2D
@export var texture_heads: Texture2D
@export var texture_tails: Texture2D
@export var coins_needed: int = 1 : set = set_coins_needed

@onready var shadow = %Shadow
@onready var light = %Light
@onready var count_label = $CountLabel

var is_available = true
var inserted_coins: Array[Coin]
var used_coins: Array[Coin]
var current_coin: Coin

# Called when the node enters the scene tree for the first time.
func _ready():
	set_available()
#	update_texture()
	coins_changed.emit(coins_needed, inserted_coins.size())
	EventBus.started_dragging.connect(_on_started_dragging)
	EventBus.stopped_dragging.connect(_on_stopped_dragging)
	# Señales para marcar disponibilidad cuando se selecciona una moneda, posiblemente
	# crear una función distinta con una animación.
	EventBus.was_selected.connect(_on_started_dragging)
	EventBus.released_selected.connect(_on_stopped_dragging)

func set_facing(value: Coin.Facing):
	facing = value
	match facing:
		Coin.Facing.ANY:
			heads_ok = true
			tails_ok = true
			texture_normal = texture_any
		Coin.Facing.HEADS:
			heads_ok = true
			tails_ok = false
			texture_normal = texture_heads
		Coin.Facing.TAILS:
			heads_ok = false
			tails_ok = true
			texture_normal = texture_tails
	
func set_coins_needed(value):
	coins_needed = value
	coins_changed.emit(coins_needed, inserted_coins.size())
	

func update_texture():
	if heads_ok:
		texture_normal = texture_any if tails_ok else texture_heads
	else:
		texture_normal = texture_tails if tails_ok else texture_any
		

#func update_count_ui():
#	if coins_needed == 1 or (coins_needed - inserted_coins.size()) == 0:
#		count_label.text = ""
#	else:
#		count_label.text = "x "+ str(coins_needed - inserted_coins.size())

func _can_drop_data(_at_position, data):
	return is_coin_compatible(data["heads"])

func _drop_data(_at_position, data):
	if data["origin_node"] is Coin:
		insert_coin(data["origin_node"])

func _on_started_dragging(object):
	if is_available and object is Coin and is_coin_compatible(object.heads):
		light.show()

func _on_stopped_dragging(object):
	if object is Coin:
		light.hide()

func _on_focus_changed(focus):
	if focus is Coin:
		current_coin = focus

func set_available():
	is_available = true
	shadow.hide()

func is_coin_compatible(is_heads: bool):
	return is_available and (is_heads and heads_ok) or (not is_heads and tails_ok)

func set_unavailable():
	is_available = false
	shadow.show()

func set_done():
	inserted_coins = []

func insert_coin(coin: Coin) -> bool:
	if coin != null and is_coin_compatible(coin.heads):
		inserted_coins.append(coin)
		coin.set_inserted()
		coins_changed.emit(coins_needed, inserted_coins.size())
		if inserted_coins.size() == coins_needed:
			set_unavailable()
		coin_inserted.emit(self, coin)
		return true
	else:
		return false

func release_inserted_coins():
	for coin in inserted_coins:
		coin.set_available()
	inserted_coins = []
	coins_changed.emit(coins_needed, inserted_coins.size())
#	set_available()
	
func use_coins():
	for coin in inserted_coins:
		coin.set_spent()
	# Añade a used_coins las monedas que no van a eliminarse.
	used_coins += inserted_coins.filter(func(element): return not element.is_queued_for_deletion())
	inserted_coins = []
	coins_changed.emit(coins_needed, inserted_coins.size())
	
func release_all_coins():
	for coin in inserted_coins:
		if coin != null:
			coin.set_available()
	for coin in used_coins:
		if coin != null:
			coin.set_available()
	inserted_coins = []
	used_coins = []
	coins_changed.emit(coins_needed, inserted_coins.size())
#	set_available()

# Reenvía una señal con referencia al propio nodo cuando se le hace click.
func _on_pressed():
	was_pressed.emit(self)

