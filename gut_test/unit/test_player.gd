extends GutTest

var player: Player
# Localización del script de la clase de equipamiento, para generar Double
var equip_script = load("res://Items/equipment/equipment.gd")
var skill_script = load("res://Battle/skills/SkillData.gd")

## Se ejecuta una sola vez antes de todos los test
func before_all():
	# Registra la clase contenida en el script
	register_inner_classes(equip_script)
	register_inner_classes(skill_script)

func before_each():
	player = Player.new()

## Comprueba si la función equip() añade el elemento a la lista de equipamiento
## del jugador, usando Double para no depender del código real de Equipment
func test_equip():
	# Crea un Double a partir de Equipment
	var equip_double = double(equip_script).new()
	player.equip(equip_double)
	assert_eq(player.equipment_list.size(), 1)

## Comprueba si la función unequip() retira al elemento de la lista del jugador
func test_unequip():
	var equip_double = double(equip_script).new()
	player.equip(equip_double)
	player.unequip(equip_double)
	assert_eq(player.equipment_list.size(), 0)

func test_bankrupt():
	watch_signals(player)
	player.stats.coin_count = 0
	player.start_turn()
	assert_signal_emitted(player, 'bankrupt')
	
