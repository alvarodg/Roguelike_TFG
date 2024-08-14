extends Control
class_name EquipmentIcon

var equipment: Equipment
@onready var sprite = %Sprite
#@onready var label_container = %LabelContainer
@onready var hover_panel = %HoverPanel
@onready var hover_label = %HoverLabel
#@onready var info_panel = %InfoPanel
#@onready var info_label = %InfoLabel
@onready var shadow = %Shadow
@onready var event_counter_container = %EventCounterContainer
@onready var trigger_counter_container = %TriggerCounterContainer


@export var corner: HoverContainer.Corner: set = set_corner

var event_counter_scene = preload("res://Items/equipment/equipment_event_counter.tscn")
var trigger_counter_scene = preload("res://Items/equipment/trigger_counter.tscn")
var hover_container_scene = preload("res://Battle/player/hover_container.tscn")

var hover_container: HoverContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	shadow.hide()
	hover_panel.hide()
	#label_container.hide()
	HoverPanel.move_to_corner(hover_panel, corner, sprite.position, sprite.texture.get_size()*sprite.scale)

func setup(p_equipment: Equipment):
	equipment = p_equipment
	equipment.triggered.connect(_on_Equipment_triggered)
	sprite.texture = equipment.ui_data.icon
	hover_label.text = equipment.ui_data.ui_name + ":\n" +equipment.get_description()
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

func _move_to_corner(p_hover_panel, to_corner: HoverContainer.Corner, target_pos: Vector2, target_size: Vector2):
	if p_hover_panel != null:
		match to_corner:
			HoverContainer.Corner.TOP_LEFT:
				p_hover_panel.anchors_preset = PRESET_BOTTOM_RIGHT
				#hover_panel.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
				var sprite_point = - target_size
				p_hover_panel.position += target_pos + sprite_point
			HoverContainer.Corner.TOP_RIGHT:
				p_hover_panel.anchors_preset = PRESET_BOTTOM_LEFT
				#hover_panel.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
				#var sprite_point = - sprite.texture.get_size() * sprite.scale
				var sprite_point = Vector2(target_size.x, -target_size.y) 
				p_hover_panel.position += sprite.position + sprite_point
			HoverContainer.Corner.BOTTOM_LEFT:
				p_hover_panel.anchors_preset = PRESET_TOP_RIGHT
				#var sprite_point = - sprite.texture.get_size() * sprite.scale
				var sprite_point = Vector2(-target_size.x, target_size.y)
				p_hover_panel.position += sprite.position + sprite_point
			HoverContainer.Corner.BOTTOM_RIGHT:
				p_hover_panel.anchors_preset = PRESET_TOP_LEFT
				var sprite_point = target_size
				p_hover_panel.position += sprite.position + sprite_point

func _on_mouse_entered():
	hover_panel.show()
	#var desc = 	equipment.ui_data.ui_name + ":\n" +equipment.get_description()
	#hover_container = hover_container_scene.instantiate()
	#hover_container.setup(desc, sprite.position, sprite.texture.get_size() * sprite.scale)
	#add_child(hover_container)
	#hover_container.move_to_corner(corner)
	#_move_to_corner(corner)
	
func _on_mouse_exited():
	hover_panel.hide()
	#hover_container.queue_free()

func set_corner(to_corner):
	corner = to_corner
	if sprite != null:
		HoverPanel.move_to_corner(hover_panel, corner, sprite.position, sprite.texture.get_size()*sprite.scale)
