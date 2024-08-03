extends Resource
class_name MapGenerator

const SAVE_KEYS = []

## Tipo de retorno requerido: Array[Array[EventNode]] 
## (Godot no permite indicar listas anidadas como tipo de retorno)
## Se esperará que los objetos EventNode que se devuelvan tengan sus coordenadas
## y referencias a sus descendientes asignadas.
func generate(_rng: RandomNumberGenerator) -> Array:
	return []
