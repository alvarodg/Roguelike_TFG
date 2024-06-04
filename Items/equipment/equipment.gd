extends Resource
class_name Equipment

## Señal que se envia cuando se activa un disparador de sus ConditionTrigger
signal triggered
## Señal que se envía con una referencia al equipamiento cuando se rompa
signal broke(equipment)

## enum para filtrar el equipamiento
enum Tag {DEFAULT, LIGHT, DARK, FALLEN, COIN, CURSED, LUCKY, CONDITIONAL, ENEMY}

## Datos para la interfaz
@export var ui_data: EquipmentUIData = EquipmentUIData.new()
## Descripción del equipo (sobreescribe a la autogenerada si no esta vacía)
@export var description: String = ""
## Parámetro que se usa para modificar la probabilidad de aparación del objeto
## en distribuciones aleatorias. (Mayor = Menos probabilidad)
@export var rarity: int = 1
## Modificadores que se aplican al usuario que equipe el objeto
@export var modifiers: Array[Modifier]
## Disparadores condicionales asociados con el equipamiento
@export var condition_triggers: Array[ConditionTrigger]
## Un equipamiento frágil se rompe al final del combate
@export var fragile: bool = false
## Lista de tags
@export var tags: Array[Tag] = [Tag.DEFAULT]

## Aplica los modificadores al usuario y conecta las señales de los disparadores
func attach_to(user):
	for mod in modifiers:
		mod.apply_to(user)
	for trigger in condition_triggers:
		trigger.apply_to(user)
	if fragile: user.ended_battle.connect(_on_battle_ended)

## Conecta las señales de los disparadores al usuario
## (Usado para reconectar señales sin volver a aplicar los modificares)
func connect_to(user):
	for trigger in condition_triggers:
		trigger.apply_to(user)
	if fragile: user.ended_battle.connect(_on_battle_ended)

## Desconecta las señales y deshace los modificadores
func detach_from(user):
	for mod in modifiers:
		mod.undo_from(user)
	for trigger in condition_triggers:
		if trigger.triggered.is_connected(_on_triggered):
			trigger.triggered.disconnect(_on_triggered)

## Inicializa los disparadores y los conecta 
## a la función que envía la señal al completarlos
func setup():
	for trigger in condition_triggers:
		if not trigger.triggered.is_connected(_on_triggered):
			trigger.triggered.connect(_on_triggered)
		trigger.setup()

## Envía la señal
func _on_triggered():
	triggered.emit()

## Genera y devuelve la descripción si no tiene una, si no devuelve 'description'
func get_description() -> String:
	if description == "":
		var desc = ""
		for mod in modifiers:
			if desc != "": desc += "\n"
			desc += mod.get_description()
		for trigger in condition_triggers:
			if desc != "": desc += "\n"
			desc += trigger.get_description()
		return desc
	else: 
		return description

## Indica que el equipamiento se ha roto al terminar la battala si 'fragile'
## El usuario que reciba la señal será el encargado de desequiparlo.
func _on_battle_ended():
	if fragile: broke.emit(self)
