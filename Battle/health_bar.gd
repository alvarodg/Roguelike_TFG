extends ProgressBar

signal health_animation_finished

@export var anim_speed: float = 1.0
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

	
func _on_Combatant_health_changed(_old, health):
	var tween = get_tree().create_tween()
	var time = (abs(value - health)/max_value) / anim_speed
	tween.tween_property(self, "value", health, time)
	await tween.finished
#	print("Tween finished")
	health_animation_finished.emit()
#	value = health
#	_update_label()
	
func _on_Combatant_max_health_changed(_old, max_health):
	max_value = max_health


func _on_value_changed(new_value):
	health_label.text = str(int(new_value)) + " HP"
