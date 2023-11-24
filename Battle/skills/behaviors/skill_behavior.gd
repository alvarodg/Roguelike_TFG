extends Resource
class_name SkillBehavior

# Usa la habilidad desde el usuario (user) hasta un posible objetivo (target), con la lista de monedas utilizadas (coins).
func use(_user, _target, _coins):
	pass

# Genera una descripción de las funciones de la habilidad a partir de sus parámetros
func get_description() -> String:
	return "Does nothing"
