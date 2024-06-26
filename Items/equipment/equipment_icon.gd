extends Control
class_name EquipmentIcon

var equipment: Equipment
@onready var sprite = %Sprite
@onready var info_panel = %InfoPanel
@onready var info_label = %InfoLabel
@onready var shadow = %Shadow
@onready var event_counter_container = %EventCounterContainer
@onready var trigger_counter_container = %TriggerCounterContainer

var event_counter_scene = preload("res://Items/equipment/equipment_event_counter.tscn")
var trigger_counter_scene = preload("res://Items/equipment/trigger_counter.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	shadow.hide()
	info_label.hide()

func setup(p_equipment: Equipment):
	equipment = p_equipment
	equipment.triggered.connect(_on_Equipment_triggered)
	sprite.texture = equipment.ui_data.icon
	info_label.text = equipment.ui_data.ui_name + ":\n" +equipment.get_description()
	for trigger in equipment.condition_triggers:
		trigger.triggers_changed.connect(_on_triggers_changed)
		if trigger.event_condition is EventCondition:
			var event_counter = event_counter_scene.instantiate()
			event_counter_container.add_child(event_counter)
			event_counter.set_anchors_preset(LayoutPreset.PRESET_BOTTOM_RIGHT)
			event_counter.setup(trigger)
		if trigger.amount > 0:
			var trigger_counter = trigger_counter_scene.instantiate()
			trigger_counter_container.add_child(trigger_counter)
			trigger_counter.set_anchors_preset(LayoutPreset.PRESET_TOP_LEFT)
			trigger_counter.setup(trigger)

func _on_triggers_changed(amount: int, remaining: int):
	if amount > 0 and remaining == 0:
		shadow.show()
		event_counter_container.hide()
#		trigger_counter_container.hide()
	else:
		shadow.hide()
		event_counter_container.show()
#		trigger_counter_container.show()

func _on_Equipment_triggered():
	var tween = get_tree().create_tween()
	var default_mod = sprite.self_modulate
	tween.tween_property(self, "sprite:self_modulate", Color.GRAY, 0.1)
	tween.tween_property(self, "sprite:self_modulate", default_mod, 0.1)

# Versión básica de mostrar la información cuando se pase el ratón
func _on_mouse_entered():
	info_label.show()

func _on_mouse_exited():
	info_label.hide()
