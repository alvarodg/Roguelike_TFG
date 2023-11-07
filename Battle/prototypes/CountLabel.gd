extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_Slot_coins_changed(coins_needed, current_coins):
	if coins_needed == 1 or (coins_needed - current_coins) == 0:
		text = ""
	else:
		text = "x "+ str(coins_needed - current_coins)
