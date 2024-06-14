extends EventData
class_name EquipmentChoiceData

@export var choices: int = 3
@export var equip_collection: EquipmentCollection
@export var equip_tags: Array[Equipment.Tag]
@export var tag_op: Collection.Operator = Collection.Operator.OR
@export var rarities: Array[int]
@export var rarity_factor: float = 1.0
@export var deterministic: bool = true

func instantiate_scene(player: Player):
	scene = load("res://Events/equipment_choice.tscn")
	var instance: EquipmentChoice = scene.instantiate()
	instance.initialize(player, self)
	return instance
