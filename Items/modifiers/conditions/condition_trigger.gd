extends Resource
class_name ConditionTrigger

## Señal que se enviará cuando se cumplan todos los estados, con true como parámetro.
signal state_ok(value)
## Señal que se enviará cuando cambien los disparos disponibles. 
signal triggers_changed(amount, remaining)
## Señal que se enviará cuando se ejecute el efecto.
signal triggered

## enum que se usará para seleccionar cuando se reiniciará el contador de disparos.
## PER_TURN: Al principio del turno del usuario.
## PER_BATTLE: Al principio de cada combate.
## PERMANENT: No se reiniciará nunca.
enum Reset {PER_TURN, PER_BATTLE, PERMANENT}

var turn_manager = preload("res://Battle/resources/TurnManager.tres")
## Condiciones que tendrán que cumplirse en el momento para que se pueda ejecutar el efecto.
@export var state_conditions: Array[StateCondition]
## Condición que indica el momento en el que se ejecutará el efecto.
@export var event_condition: EventCondition
## Modificadores que el efecto aplicará al usuario.
@export var modifiers: Array[Modifier]
## Cantidad máxima de disparos disponibles en el efecto (-1 = infinitos).
@export var amount: int = -1
## Cuando se reiniciará el contador de disparos disponibles.
@export var reset: Reset = Reset.PER_BATTLE
## Usuario del efecto
var user
## Disparos disponibles actualmente.
var triggers_remaining: int : set = set_triggers_remaining
## Estado actual de cumplimiento de cada condición de estado.
var current_state: Array[bool]

## Constructor
func _init(p_state_conditions: Array[StateCondition] = [], 
			p_event_condition: EventCondition = null, p_modifiers: Array[Modifier] = [], 
			p_amount: int = -1, p_reset: Reset = Reset.PER_BATTLE):
	state_conditions = p_state_conditions
	event_condition = p_event_condition
	modifiers = p_modifiers
	amount = p_amount
	reset = p_reset
	triggers_remaining = amount
	
## Asigna los valores por defecto a triggers_remaining (amount) y 
## current_state (Array[bool] a false con un elemento por condición de estado)
func setup():
	triggers_remaining = amount
	var temp: Array[bool] = []
	temp.resize(state_conditions.size())
	temp.fill(false)
	current_state = temp
	
## Setter de triggers_remaining
func set_triggers_remaining(value):
	triggers_remaining = value
	triggers_changed.emit(amount, triggers_remaining)

## Conecta el disparador a su usuario, un Combatant p_user.
func apply_to(p_user: Combatant):
	user = p_user
	# Conecta las condiciones de estado al jugador y _on_state_changed
	# (si no están ya conectadas).
	for state in state_conditions:
		state.connect_to(user)
		if not state.state_changed.is_connected(_on_state_changed):
			state.state_changed.connect(_on_state_changed)
	# Conecta la condición de evento al jugador y _on_triggered 
	# (si no está ya conectada).
	if event_condition is EventCondition:
		event_condition.connect_to(user)
		if not event_condition.met.is_connected(_on_triggered):
			event_condition.met.connect(_on_triggered)
	# Si no tiene condición de evento, conecta state_ok a _on_triggered directamente,
	# se ejecutará la función en cuanto se cumplan todas las condiciones de estado.
	else:
		state_ok.connect(_on_triggered)
	# Conecta a las señales necesarias para el reinicio del disparador
	_connect_reset_signals(user)
	
## Aplica los efectos al usuario si se puede.
func _on_triggered(_param = null):
	if _can_trigger():
		for mod in modifiers:
			mod.apply_to(user)
		triggers_remaining -= 1
		triggered.emit()

## Indica si el disparador puede ejecutarse, comprobando si quedan disparos
## y si se cumplen todas las condiciones de estado.
func _can_trigger() -> bool:
	return triggers_remaining != 0 and current_state.all(func(x): return x==true)

## Conecta el reinicio a las señales del usuario o el gestor de turnos,
## según el modo de reinicio
func _connect_reset_signals(p_user):
	if p_user is Player:
		if reset == Reset.PER_TURN and not turn_manager.player_turn_started.is_connected(_reset_triggers_remaing):
			turn_manager.player_turn_started.connect(_reset_triggers_remaing)
	if p_user is Enemy:
		if reset == Reset.PER_TURN and not turn_manager.enemy_turn_started.is_connected(_reset_triggers_remaing):
			turn_manager.enemy_turn_started.connect(_reset_triggers_remaing)
	if amount > 0 and reset == Reset.PER_BATTLE:
		p_user.started_battle.connect(_reset_triggers_remaing)

## Actualiza current_state cada vez que cambie un estado.
func _on_state_changed(state_ref, value):
	if current_state.size() > 0:
		current_state[state_conditions.find(state_ref)] = value
	# Si cumple todas las condiciones de estado, envía state_ok(true)
	if current_state.all(func(x): return x==true):
		state_ok.emit(true)

## Reinicia la cantidad de disparos disponibles.
func _reset_triggers_remaing():
	triggers_remaining = amount

## Genera y devuelve la descripción automática del disparador.
func get_description() -> String:
	var desc: String = ""
	var cond_text: String = ""
	var mod_text: String = ""
#	var start: String = "If:" if event_condition is EventCondition else "When:"
	for state in state_conditions:
		if state_conditions.size() == 1:
			cond_text += "If " if event_condition is EventCondition else "When "
			cond_text += state.get_description() + ":"
		else:
			if cond_text == "": cond_text += "If:" if event_condition is EventCondition else "When:"
	#		if cond_text != "": cond_text += "\n\t"
			var state_desc: String = state.get_description()
			if state_desc.length() > 0:
				state_desc = state_desc[0].to_upper() + state_desc.substr(1,-1)
			cond_text += "\n* " + state.get_description()
	if event_condition is EventCondition:
		cond_text += "\nWhen " + event_condition.get_description() + ":"
	else:
		cond_text += "\nDo:"
	desc += cond_text
	for mod in modifiers:
#		if mod_text == "": mod_text += "Do:"
		if mod_text != "": mod_text += "\n"
		mod_text += "* " + mod.get_description()
	desc += "\n" + mod_text
	if amount != -1:
		var plural: String = "" if amount==1 else "s"
		var frequency: String
		match reset:
			Reset.PER_TURN:
				frequency = " per turn"
			Reset.PER_BATTLE:
				frequency = " per battle"
			Reset.PERMANENT:
				frequency = ""
		
		desc += "\n(%d time%s%s)" % [amount, plural, frequency]
	return desc.strip_edges()
