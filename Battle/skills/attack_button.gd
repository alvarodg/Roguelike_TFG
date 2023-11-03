extends SkillButton

var damage: int = 10
var cost: int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_pressed():
	if combatants.player.energy >= cost:
		combatants.player.energy -= cost
		combatants.enemy.health -= damage
	else:
		print("Out of energy!")
