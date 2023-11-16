extends Control

signal finished

@onready var choice_container = %ChoiceContainer
var choices: Array
var next_event: EventData

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func add_choice(choice):
	choices.append(choice)

func finish():
	if next_event is EventData:
		var next_scene = next_event.instantiate_scene()
		get_parent().add_child(next_scene) 
		hide()
		await next_scene.finished
	finished.emit()
	queue_free()

# Hardcoding TEMPORAL para el prototipo. ¿Usar patrón Command para decisiones?
func _on_EnergyButton_pressed():
	if RunData.player.stats.health <= 10:
		print("Not enough health.")
		return
	RunData.player.stats.coin_count += 1
	RunData.player.stats.health -= 10
	finish()

func _on_HealthButton_pressed():
	RunData.player.stats.health += 30
	finish()
	
func _on_LuckButton_pressed():
	RunData.player.stats.base_luck += 0.1
	finish()

func _on_SkipButton_pressed():
	finish()
