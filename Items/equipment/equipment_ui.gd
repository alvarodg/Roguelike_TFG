extends Control

signal equipment_changed(equipment_list)
signal empty
signal not_empty

@export var columns: int = 5
@export var panel_style: StyleBox
#var equipment_list: Array[Equipment]
@onready var equip_icon_scene = preload("res://Items/equipment/equipment_icon.tscn")
@onready var equipment_grid = %EquipmentGrid
@onready var panel_container = %PanelContainer

@export var corner: HoverContainer.Corner: set = set_corner

# Called when the node enters the scene tree for the first time.
func _ready():
	equipment_grid.columns = columns
	if panel_style != null:
		panel_container.add_theme_stylebox_override("panel", panel_style)

func setup(user):
	assert(user is Player or user is Enemy)
	user.equipment_changed.connect(_on_User_equipment_changed)
	reset_equipment_icons(user.equipment_list)

func _on_User_equipment_changed(p_equipment_list):
	reset_equipment_icons(p_equipment_list)

func reset_equipment_icons(equipment_list: Array):
	if equipment_list.size() == 0:
		empty.emit()
	else:
		not_empty.emit()
		for icon in equipment_grid.get_children():
			if icon is EquipmentIcon: icon.queue_free()
		for equipment in equipment_list:
			var equip_icon = equip_icon_scene.instantiate()
			equip_icon.corner = corner
			equipment_grid.add_child(equip_icon)
			equip_icon.setup(equipment)
		equipment_changed.emit(equipment_list)

func set_corner(to_corner):
	corner = to_corner
	if equipment_grid != null:
		for equipment in equipment_grid.get_children():
			if equipment is EquipmentIcon:
				equipment.corner = corner
