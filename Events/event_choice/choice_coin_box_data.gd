extends Resource
class_name ChoiceCoinBoxData

@export var coin_amount: int = 1
@export var target_heads: int = 1
@export var operator: ChoiceCoinBox.Operator = ChoiceCoinBox.Operator.MORE_OR_EQUAL
var scene = load("res://Events/event_choice/choice_coin_box.tscn")

func create_instance() -> ChoiceCoinBox:
	var instance: ChoiceCoinBox = scene.instantiate()
	instance.initialize(self)
	return instance
