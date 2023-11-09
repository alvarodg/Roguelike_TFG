extends Button

@onready var combatants = load("res://Battle/resources/Combatants.tres")

@export var skill_name: String = "Attack"
@export var damage: int = 10
@export var light_cost: int = 1
@export var dark_cost: int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	text = "%s\n%s Damage\n%s Light, %s Dark" % [skill_name, damage, light_cost, dark_cost]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_pressed():
	if combatants.player.light_energy >= light_cost and combatants.player.dark_energy >= dark_cost:
		combatants.player.light_energy -= light_cost
		combatants.player.dark_energy -= dark_cost
		combatants.enemy.stats.health -= damage
	else:
		print("Not enough energy!")
