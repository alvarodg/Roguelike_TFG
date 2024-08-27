extends Control

signal health_animation_finished

signal _tween_queue_free

@export var anim_speed: float = 1.0
@export var default_style: StyleBox
@export var shield_style: StyleBox
@export var left_side: bool = true
@onready var health_label = %HealthLabel
@onready var health_bar = %HealthProgressBar
@onready var shield_icon = %ShieldIcon
@onready var shield_label = %ShieldLabel
@onready var remaining_label = %RemainingLabel
@onready var max_health_label = %MaxHealthLabel
@onready var hover_panel = %HoverPanel
@onready var hover_label = %HoverLabel

var tween_queue: int = 0 : set = set_tween_queue

# Called when the node enters the scene tree for the first time.
func _ready():
	health_label.show()
	max_health_label.hide()

func setup(combatant: CombatantStats):
	health_bar.max_value = combatant.max_health
	health_bar.value = combatant.health
	_update_shield(combatant.shield)
	_update_remaining(combatant.shield_turns_remaining)
	combatant.health_changed.connect(_on_Combatant_health_changed)
	combatant.max_health_changed.connect(_on_Combatant_max_health_changed)
	combatant.shield_changed.connect(_on_Combatant_shield_changed)
	combatant.shield_turns_remaining_changed.connect(_on_Combatant_remaining_changed)
	
func _on_Combatant_health_changed(_old, health, _max_health):
	var tween = get_tree().create_tween()
	var time = (abs(health_bar.value - health)/health_bar.max_value) / anim_speed
	tween.tween_property(health_bar, "value", health, time)
	await tween.finished
#	print("Tween finished")
	health_animation_finished.emit()
#	value = health
#	_update_label()
	
func _on_Combatant_max_health_changed(_old, max_health):
	health_bar.max_value = max_health

func _on_Combatant_shield_changed(old, shield):
	if tween_queue > 0:
		await _tween_queue_free
	tween_queue += 1
	var tween = get_tree().create_tween()
	#if old==0 and shield > 0:
		#tween.tween_property(shield_icon, "modulate", Color.WHITE, 0.2)
		#await tween.finished
		#shield_icon.modulate = Color.WHITE
	var time = 0.1 * sqrt(abs(shield-old))
	tween.tween_method(_update_shield, old, shield, time)
	await tween.finished
	#if shield == 0:
		#shield_icon.modulate = Color.TRANSPARENT
	_update_shield(shield)
	tween_queue -= 1

func _on_Combatant_remaining_changed(old, remaining):
	_update_remaining(remaining)

func _update_shield(shield):
	shield_label.text = str(shield)
	if shield > 0:
		shield_icon.show()
		health_bar.add_theme_stylebox_override("fill", shield_style)
		#health_bar.add_theme_constant_override("outline_size", 2)
	else:
		#var tween = get_tree().create_tween()
		#tween.tween_property(shield_icon, "modulate", Color.TRANSPARENT, 0.2)
		#await tween.finished
		shield_icon.hide()
		health_bar.add_theme_stylebox_override("fill", default_style)
		#health_bar.add_theme_constant_override("outline_size", 0)

func _on_HealthProgressBar_value_changed(new_value):
	health_label.text = str(int(new_value)) + " HP"
	max_health_label.text = str(int(new_value)) + "/" + str(health_bar.max_value) + " HP"

func _update_remaining(remaining):
	if remaining < 0:
		remaining_label.show()
		hover_label.text = "Shield: Takes damage before health. Will NOT decay."
		remaining_label.text = "∞"
	else:
		hover_label.text = "Shield: Takes damage before health. Will decay at the start of the next turn."
		remaining_label.hide()

func set_tween_queue(value):
	tween_queue = value
	if tween_queue == 0:
		_tween_queue_free.emit()


func _on_HealthProgressBar_mouse_entered():
	health_label.hide()
	max_health_label.show()


func _on_HealthProgressBar_mouse_exited():
	health_label.show()
	max_health_label.hide()


func _on_ShieldIcon_mouse_entered():
	hover_panel.global_position = get_global_mouse_position()
	if left_side:
		hover_panel.global_position.y -= hover_panel.size.y
	else:
		hover_panel.global_position.x -= hover_panel.size.x
	hover_panel.show()


func _on_ShieldIcon_mouse_exited():
	hover_panel.hide()
