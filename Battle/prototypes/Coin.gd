extends TextureButton
class_name Coin

@export var heads: bool = true : set = set_heads
@export var heads_texture: Texture2D
@export var tails_texture: Texture2D
@export var heads_chance = 0.5
var drag_preview_scene: PackedScene = preload("res://Battle/prototypes/drag_preview.tscn")

enum Status {AVAILABLE, INSERTED, SPENT}
var status: Status

# Called when the node enters the scene tree for the first time.
func _ready():
	set_available()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func flip(mod: float = 1.0) -> bool:
	heads = heads_chance * mod > randf()
	return heads

func set_heads(value):
	heads = value
	set_facing_texture()

func set_facing_texture():
	texture_normal = heads_texture if heads else tails_texture

func _get_drag_data(at_position):
	if status != Status.AVAILABLE:
		return null
	var data = {}
	data["origin_node"] = self
	data["heads"] = heads
	var drag_preview = drag_preview_scene.instantiate()
	drag_preview.texture = texture_normal
	add_child(drag_preview)
	return data

func set_available():
	status = Status.AVAILABLE
	set_facing_texture()
	
func set_inserted():
	status = Status.INSERTED
	texture_normal = null
	
func set_spent():
	status = Status.SPENT
	texture_normal = null
	
