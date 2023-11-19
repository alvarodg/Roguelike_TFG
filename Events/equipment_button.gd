extends Button

signal equipment_chosen(equipment)

@export var equipment: Equipment
@export var player: Player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = RunData.player
	text = equipment.ui_data.ui_name + ":\n" + equipment.get_description()

func setup(p_player: Player, p_equipment: Equipment):
	player = p_player
	equipment = p_equipment


func _on_pressed():
	player.equip(equipment)
	RunData.collections.remove_equipment(equipment)
#	equipment_chosen.emit(equipment)
