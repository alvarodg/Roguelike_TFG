extends TextureButton
class_name Slot

signal coin_inserted(coin)

@export var heads_ok: bool = true
@export var tails_ok: bool = true
@export var texture_any: Texture2D
@export var texture_heads: Texture2D
@export var texture_tails: Texture2D
@onready var shadow = %Shadow
var available = true
var inserted_coin: Coin

# Called when the node enters the scene tree for the first time.
func _ready():
	set_available()
	update_texture()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_heads_ok(value):
	heads_ok = value
	update_texture()

func set_tails_ok(value):
	tails_ok = value
	update_texture()
	
func set_heads_only():
	heads_ok = true
	tails_ok = false
	
func set_tails_only():
	heads_ok = false
	tails_ok = true
	
func set_any():
	heads_ok = true
	tails_ok = true

func update_texture():
	if heads_ok:
		texture_normal = texture_any if tails_ok else texture_heads
	else:
		texture_normal = texture_tails if tails_ok else texture_any
		

func _can_drop_data(at_position, data):
	return available and (data["heads"] and heads_ok) or (not data["heads"] and tails_ok)

func _drop_data(at_position, data):
	inserted_coin = data["origin_node"]
	inserted_coin.set_inserted()
	set_unavailable()
	coin_inserted.emit(inserted_coin)
	print(data["heads"])

func set_available():
	available = true
	shadow.hide()

func set_unavailable():
	available = false
	shadow.show()

func set_done():
	inserted_coin = null

func release_coin():
	if inserted_coin is Coin:
		inserted_coin.set_available()
		inserted_coin = null
		set_available()


	
