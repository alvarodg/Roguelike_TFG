extends TextureButton
class_name Coin

@export var data: CoinData
@export var heads: bool = true : set = set_heads
@export var heads_texture: Texture2D
@export var tails_texture: Texture2D
@export var heads_chance = 0.5
@export var is_ephemeral: bool = false
var drag_preview_scene: PackedScene = preload("res://Battle/coin_ui/drag_preview.tscn")
var is_dragging: bool = false
var is_selected: bool = false : set = set_is_selected

enum Status {AVAILABLE, INSERTED, SPENT}
var status: Status = Status.AVAILABLE

@onready var selected = %Selected

# Called when the node enters the scene tree for the first time.
func _ready():
#	set_available()
	pass

func setup(p_data: CoinData):
	data = p_data
	heads = data.default_heads

func _input(event):
	if event.is_action_released("click") and is_dragging:
		EventBus.stopped_dragging.emit(self)
		is_dragging = false
		set_facing_texture()

func flip(mod: float = 1.0) -> bool:
	heads = data.heads_chance * mod > randf()
	return heads

func set_heads(value):
	heads = value
	set_facing_texture()

func set_facing_texture():
	texture_normal = data.heads_texture if heads else data.tails_texture
	# Puede mejorarse, hace la moneda medio transparente si es ephemeral
	modulate.a = 0.5 if is_ephemeral else 1.0
	

func _get_drag_data(_at_position):
	release_focus()
	if status != Status.AVAILABLE:
		return null
	var drag_data = {}
	drag_data["origin_node"] = self
	drag_data["heads"] = heads
	var drag_preview = drag_preview_scene.instantiate()
	drag_preview.texture = texture_normal
	make_invisible()
	add_child(drag_preview)
	EventBus.started_dragging.emit(self)
	is_dragging = true
	return drag_data

func make_invisible():
	texture_normal = null

func set_available():
	status = Status.AVAILABLE
	focus_mode = Control.FOCUS_ALL
	set_facing_texture()
	
func set_inserted():
	status = Status.INSERTED
	focus_mode = Control.FOCUS_NONE
	make_invisible()
	
func set_spent():
	status = Status.SPENT
	focus_mode = Control.FOCUS_NONE
	make_invisible()

func set_is_selected(value):
	is_selected = value

func get_ephemeral_copy() -> Coin:
	var e_coin = self.duplicate()
	e_coin.is_ephemeral = true
	e_coin.set_available()
	return e_coin


func _on_pressed():
	if status == Status.AVAILABLE:
		is_selected = true
		print(is_selected)
		grab_focus()
#	EventBus.was_selected.emit(self)
