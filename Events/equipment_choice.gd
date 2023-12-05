extends EventScene

@onready var choice_container = %ChoiceContainer
@onready var equipment_button_scene = preload("res://Events/equipment_button.tscn")
@export var choices: int = 3
var equip_list: Array[Equipment]

# Called when the node enters the scene tree for the first time.
func _ready():
	if equip_list.size() == 0:
		equip_list = RunData.collections.get_random_equipment_list(choices)
	for equipment in equip_list:
		var equip_button = equipment_button_scene.instantiate()
		equip_button.setup(RunData.player, equipment)
		equip_button.pressed.connect(_on_EquipButton_pressed)
		choice_container.add_child(equip_button)
		

func setup(p_choices = 3, fixed_equip_list: Array[Equipment] = []):
	choices = p_choices
	equip_list = fixed_equip_list


func _on_EquipButton_pressed():
	finish()

func _on_SkipButton_pressed():
	finish()


