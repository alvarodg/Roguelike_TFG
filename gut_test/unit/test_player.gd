extends GutTest

var player: Player
var equip_script = load("res://Items/equipment/equipment.gd")
var skill_script = load("res://Battle/skills/SkillData.gd")


func before_all():
	register_inner_classes(equip_script)
	register_inner_classes(skill_script)

func before_each():
	player = Player.new()

func test_equip():
	var equip_double = double(equip_script).new()
	player.equip(equip_double)
	assert_eq(player.equipment_list.size(), 1)

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
	
