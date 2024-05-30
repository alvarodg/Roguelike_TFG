extends Button

signal equipment_chosen(equipment)

@export var equipment: Equipment
@export var player: Player

@onready var equipment_icon = %EquipmentIcon
@onready var name_label = %NameLabel
@onready var description_label = %DescriptionLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	player = RunData.player
	equipment_icon.texture = equipment.ui_data.icon
	name_label.text = equipment.ui_data.ui_name
	description_label.text = equipment.get_description()
#	text = equipment.ui_data.ui_name + ":\n" + equipment.get_description()
#	icon = equipment.ui_data.icon

func setup(p_player: Player, p_equipment: Equipment):
	player = p_player
	equipment = p_equipment


func _on_pressed():
	player.equip(equipment)
	RunData.collections.remove(equipment)
#	equipment_chosen.emit(equipment)
