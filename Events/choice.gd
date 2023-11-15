extends Control

signal finished

@onready var choice_container = %ChoiceContainer
var choices: Array

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_choice(choice):
	choices.append(choice)

func finish():
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
