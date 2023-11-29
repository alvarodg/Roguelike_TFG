extends Trigger
class_name FlipTrigger

@export var heads_modifiers: Array[Modifier]
@export var tails_modifiers: Array[Modifier]

func apply_to(p_player: Player):
	p_player.coin_flipped.connect(_on_triggered)
	super.apply_to(p_player)
	
func _on_triggered(coin: Coin = null):
	if _can_trigger():
		if coin.heads:
			for heads_mod in heads_modifiers:
				heads_mod.apply_to(player)
		else:
			for tails_mod in tails_modifiers:
				tails_mod.apply_to(player)
	super._on_triggered()

func get_description():
	var trigger_text = "When Coin is flipped:"
	var heads_desc = ""
	var tails_desc = ""
	var any_desc = ""
	for heads_mod in heads_modifiers:
		if heads_desc == "": 
			heads_desc = "\nIf Heads: " + heads_mod.get_description()
		else:
			heads_desc += "\n" + heads_mod.get_description()
	for tails_mod in tails_modifiers:
		if tails_desc == "": 
			tails_desc = "\nIf Tails: " + tails_mod.get_description()
		else:
			tails_desc += "\n" + tails_mod.get_description()
	if modifiers.size() > 0:
		any_desc = "\nAlways: "
	return trigger_text + heads_desc + tails_desc + any_desc + super.get_description()
