extends Resource
class_name SkillBehavior

signal finished(behavior)

# Usa la habilidad desde el usuario (user) hasta un posible objetivo (target), con la lista de monedas utilizadas (coins).
func use(_user, _target, _coins):
	_finish()

func _finish():
	finished.emit(self)

# Genera una descripción de las funciones de la habilidad a partir de sus parámetros
func get_description(_stats: CombatantStats = null) -> String:
	return "Does nothing"
