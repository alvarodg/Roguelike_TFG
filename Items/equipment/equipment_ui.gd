extends Control

@export var columns: int = 5
#var equipment_list: Array[Equipment]
@onready var equip_icon_scene = preload("res://Items/equipment/equipment_icon.tscn")
@onready var equipment_grid = %EquipmentGrid

# Called when the node enters the scene tree for the first time.
func _ready():
	equipment_grid.columns = columns

func setup(user):
	assert(user is Player or user is Enemy)
	user.equipment_changed.connect(_on_User_equipment_changed)
	reset_equipment_icons(user.equipment_list)

func _on_User_equipment_changed(p_equipment_list):
	reset_equipment_icons(p_equipment_list)

func reset_equipment_icons(equipment_list: Array):
	for icon in equipment_grid.get_children():
		if icon is EquipmentIcon: icon.queue_free()
	for equipment in equipment_list:
		var equip_icon = equip_icon_scene.instantiate()
		equip_icon.setup(equipment)
		equipment_grid.add_child(equip_icon)
