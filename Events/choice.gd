extends Control

signal finished

@onready var choice_container = %ChoiceContainer
@onready var equipment_button_scene = preload("res://Events/equipment_button.tscn")
@export var choices: int = 3
var choices_list: Array
var next_event: EventData

# Called when the node enters the scene tree for the first time.
func _ready():
	var equip_list = RunData.collections.get_random_equipment_list(choices)
	for equipment in equip_list:
		var equip_button = equipment_button_scene.instantiate()
		equip_button.setup(RunData.player, equipment)
		equip_button.pressed.connect(_on_EquipButton_pressed)
		choice_container.add_child(equip_button)
		

func add_choice(choice):
	choices_list.append(choice)

func finish():
	if next_event is EventData:
		var next_scene = next_event.instantiate_scene()
		get_parent().add_child(next_scene) 
		hide()
		await next_scene.finished
	finished.emit()
	queue_free()



## Hardcoding TEMPORAL para el prototipo. ¿Usar patrón Command para decisiones?
#func _on_EnergyButton_pressed():
#	if RunData.player.stats.health <= 10:
#		print("Not enough health.")
#		return
#	RunData.player.stats.coin_count += 1
#	RunData.player.stats.health -= 10
#	finish()
#
#func _on_HealthButton_pressed():
#	RunData.player.stats.health += 30
#	finish()
#
#func _on_LuckButton_pressed():
#	RunData.player.stats.base_luck += 0.1
#	finish()

func _on_EquipButton_pressed():
	finish()

func _on_SkipButton_pressed():
	finish()


