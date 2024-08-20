extends Control

@onready var health_bar = %HealthBar
@onready var equipment_ui = %EquipmentUI

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setup(player: Player):
	equipment_ui.setup(player)
	health_bar.setup(player.stats)
