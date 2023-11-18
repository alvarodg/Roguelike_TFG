extends TextureButton
class_name Coin

@export var heads: bool = true : set = set_heads
@export var heads_texture: Texture2D
@export var tails_texture: Texture2D
@export var heads_chance = 0.5
var drag_preview_scene: PackedScene = preload("res://Battle/coin_ui/drag_preview.tscn")
var is_dragging: bool = false

enum Status {AVAILABLE, INSERTED, SPENT}
var status: Status

# Called when the node enters the scene tree for the first time.
func _ready():
	set_available()

func _input(event):
	if event.is_action_released("click") and is_dragging:
		EventBus.stopped_dragging.emit(self)
		is_dragging = false
		set_facing_texture()

func flip(mod: float = 1.0) -> bool:
	heads = heads_chance * mod > randf()
	return heads

func set_heads(value):
	heads = value
	set_facing_texture()

func set_facing_texture():
	texture_normal = heads_texture if heads else tails_texture

func _get_drag_data(_at_position):
	if status != Status.AVAILABLE:
		return null
	var data = {}
	data["origin_node"] = self
	data["heads"] = heads
	var drag_preview = drag_preview_scene.instantiate()
	drag_preview.texture = texture_normal
	make_invisible()
	add_child(drag_preview)
	EventBus.started_dragging.emit(self)
	is_dragging = true
	return data

func make_invisible():
	texture_normal = null

func set_available():
	status = Status.AVAILABLE
	set_facing_texture()
	
func set_inserted():
	status = Status.INSERTED
	make_invisible()
	
func set_spent():
	status = Status.SPENT
	make_invisible()
	
