extends Resource
class_name CausesEffectTrigger

enum Reset {PER_TURN, PER_BATTLE, PERMANENT}

@export var causes: Array[Condition]
@export var effect: Modifier
@export var amount: int = -1
@export var reset: Reset = Reset.PER_BATTLE

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
