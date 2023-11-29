extends Trigger
class_name PercentHealthTrigger

@export var percent: float = 0.5

func apply_to(p_player: Player):
	p_player.started_battle.connect(_on_specific_triggered)
	p_player.stats.health_changed.connect(_on_specific_triggered)
#	turn_manager.player_turn_started.connect(_test)
	super.apply_to(p_player)

func get_description():
	return "When health under %.2f%%:\n" % [percent*100] + super.get_description()

func _on_specific_triggered(_health = 0):
	if _can_trigger():
		if player.stats.health <= percent*float(player.stats.max_health) and player.stats.health > 0:
			super._on_triggered()
