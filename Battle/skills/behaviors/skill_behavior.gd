extends Resource
class_name SkillBehavior

## Señal que se envía con una referencia al comportamiento cuando este finaliza
signal finished(behavior)

## Usa la habilidad desde el usuario (user) hasta un posible objetivo (target),
## con la lista de monedas utilizadas (coins)
## (A implementar en subclases)
func use(_user: Combatant, _target: Combatant, _coins):
	_finish()

## Envía la señal de finalizado
func _finish():
	finished.emit(self)

## Genera una descripción de las funciones de la habilidad a partir de 
## sus parámetros (A implementar en subclases)
func get_description(_stats: CombatantStats = null) -> String:
	return "Does nothing"
