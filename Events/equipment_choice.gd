extends EventScene
class_name EquipmentChoice

@onready var choice_container = %ChoiceContainer
@onready var equipment_button_scene = preload("res://Events/equipment_button.tscn")
var choices: int
var equip_collection: EquipmentCollection
var equip_tags: Array[Equipment.Tag]
var tag_op: Collection.Operator
var rarities: Array[int]
var rarity_factor: float
var deterministic: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	var equip_list: Array[Equipment] = []
	var rng = RunData.rng if deterministic else RandomNumberGenerator.new()
	if equip_collection == null or equip_collection.size() == 0:
		equip_list.assign(RunData.collections.get_random_equipment_list(choices, equip_tags, tag_op, rarities, rarity_factor))
	else:
		equip_list.assign(equip_collection.get_random_list(choices, rng, equip_tags, tag_op, rarities, rarity_factor))
	for equipment in equip_list:
		var equip_button = equipment_button_scene.instantiate()
		equip_button.setup(RunData.player, equipment)
		equip_button.pressed.connect(_on_EquipButton_pressed)
		choice_container.add_child(equip_button)
		

func initialize(p_player: Player, data: EquipmentChoiceData):
	super.initialize(p_player, data)
	choices = data.choices
	equip_collection = data.equip_collection
	equip_tags = data.equip_tags
	tag_op = data.tag_op
	rarities = data.rarities
	rarity_factor = data.rarity_factor
	deterministic = data. deterministic

func _on_EquipButton_pressed():
	finish()

func _on_SkipButton_pressed():
	finish()


