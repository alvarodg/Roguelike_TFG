extends TextureButton
class_name Coin

@onready var animation_player = $AnimationPlayer
@onready var audio_stream_player = $AudioStreamPlayer

signal flipped(coin)
signal dropped(coin)

var sounds = SystemData.sound_collection

@export var data: CoinData
@export var heads: bool = true : set = set_heads
@export var heads_texture: Texture2D
@export var tails_texture: Texture2D
@export var heads_chance = 0.5
@export var is_ephemeral: bool = false : set = set_is_ephemeral
var drag_preview_scene: PackedScene = preload("res://Battle/coin_ui/drag_preview.tscn")
var is_dragging: bool = false
var is_selected: bool = false : set = set_is_selected

var dropped_item_scene: PackedScene = preload("res://Battle/coin_ui/dropped_item.tscn")

enum Facing {ANY, HEADS, TAILS}
enum Status {AVAILABLE, INSERTED, SPENT, DROPPED}
var status: = Status.AVAILABLE

@onready var selected = %Selected

# Called when the node enters the scene tree for the first time.
func _ready():
#	set_available()
	pass

func setup(p_data: CoinData):
	data = p_data
	heads = data.default_heads
	heads_texture = data.heads_texture
	tails_texture = data.tails_texture
	heads_chance = data.heads_chance

func _input(event):
	if event.is_action_released("click") and is_dragging:
		EventBus.stopped_dragging.emit(self)
		is_dragging = false
		set_facing_texture()

func flip(mod: float = 1.0, force: Facing = Facing.ANY, 
		  rng: RandomNumberGenerator = RandomNumberGenerator.new()) -> bool:
	if force == Facing.ANY:
		heads = data.heads_chance * mod > rng.randf()
	else:
		heads = true if force == Facing.HEADS else false
	flipped.emit(self)
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
	show()
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
	hide()

func set_dropped():
	if status != Status.DROPPED:
		status = Status.DROPPED
		focus_mode = Control.FOCUS_NONE
		var dropped_item: DroppedItem = dropped_item_scene.instantiate()
		dropped_item.setup(texture_normal, global_position)
		get_tree().root.add_child(dropped_item)
		make_invisible()
		dropped.emit(self)
		hide()


func set_is_selected(value):
	is_selected = value

func set_is_ephemeral(value):
	is_ephemeral = value
	set_facing_texture()

func get_ephemeral_copy() -> Coin:
	var e_coin = self.duplicate()
	e_coin.is_ephemeral = true
	e_coin.set_available()
	return e_coin


func _on_pressed():
	if status == Status.AVAILABLE:
		is_selected = true
		grab_focus()
#	EventBus.was_selected.emit(self)

func check_facing(facing: Facing) -> bool:
	if facing == Facing.ANY:
		return true
	elif facing == Facing.HEADS:
		return heads
	else:
		return not heads

func start_spinning(amount: int = -1):
	var time = get_spin_length()
	animation_player.play("spin")
	if amount > 0:
		await get_tree().create_timer(time*amount).timeout
		stop_spinning()
	
func stop_spinning():
	animation_player.play("RESET")
	set_facing_texture()
	audio_stream_player.stream = sounds.heads if heads else sounds.tails
	audio_stream_player.play()

func get_spin_length() -> float:
	return animation_player.get_animation("spin").length

func show_heads():
	texture_normal = data.heads_texture
	texture_disabled = data.heads_texture
	
func show_tails():
	texture_normal = data.tails_texture
	texture_disabled = data.heads_texture

func fade_out():
	var tween = create_tween()
	tween.tween_property(self, "self_modulate:a", 0, 0.2)
	await tween.finished

func fade_in():
	self_modulate.a = 0
	var tween = get_tree().create_tween()
	var target = 0.5 if is_ephemeral else 1.0
	tween.tween_property(self, "self_modulate:a", target, 0.2)

func make_untouchable():
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func is_compatible(facing: Facing) -> bool:
	if facing == Facing.ANY:
		return true
	elif facing == Facing.HEADS:
		return heads
	else:
		return not heads

static func get_facing_text(facing: Facing) -> String:
	var text = ""
	match facing:
		Facing.ANY: text = "Flip"
		Facing.HEADS: text = "Heads"
		Facing.TAILS: text = "Tails"
	return text
