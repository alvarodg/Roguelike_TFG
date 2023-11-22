extends Control

@export var columns: int = 5
var equipment_list: Array[Equipment]
@onready var equip_icon_scene = preload("res://Items/equipment/equipment_icon.tscn")
@onready var equipment_grid = %EquipmentGrid

# Called when the node enters the scene tree for the first time.
func _ready():
	equipment_grid.columns = columns

func setup(p_equipment_list: Array):
	equipment_list = p_equipment_list
	for equipment in equipment_list:
		var equip_icon = equip_icon_scene.instantiate()
		equip_icon.setup(equipment)
		equipment_grid.add_child(equip_icon)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
