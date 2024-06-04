extends StateCondition
class_name InBattleCondition

## Conecta a las señales de principio y fin de batalla del jugador
func connect_to(p_user: Player):
	super.connect_to(p_user)
	p_user.started_battle.connect(_on_battle_start)
	p_user.ended_battle.connect(_on_battle_end)

## Emite la señal de cambio de estado con true al entrar en combate
func _on_battle_start():
	state_changed.emit(self, true)

## Emite la señal de cambio de estado con false al salir del combate
func _on_battle_end():
	state_changed.emit(self, false)

func get_description():
	return "in Battle"
