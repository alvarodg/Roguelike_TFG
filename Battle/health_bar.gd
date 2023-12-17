extends ProgressBar

@onready var health_label = %HealthLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func setup(combatant: CombatantStats):
	max_value = combatant.max_health
	value = combatant.health
#	_update_label()
	combatant.health_changed.connect(_on_Combatant_health_changed)
	combatant.max_health_changed.connect(_on_Combatant_max_health_changed)

	
func _on_Combatant_health_changed(health):
	var tween = get_tree().create_tween()
	var time = 5 * abs(value - health)/max_value
	tween.tween_property(self, "value", health, time)
#	value = health
#	_update_label()
	
func _on_Combatant_max_health_changed(max_health):
	max_value = max_health


func _on_value_changed(value):
	health_label.text = str(int(value)) + " HP"
