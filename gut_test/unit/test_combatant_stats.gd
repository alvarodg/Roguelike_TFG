extends GutTest

var stats: CombatantStats

func before_each():
	stats = CombatantStats.new(100)

func test_regular_damage():
	stats.take_damage(10)
	assert_eq(stats.health, 90)

func test_negative_damage():
	stats.health = 90
	stats.take_damage(-10)
	assert_eq(stats.health, 90)

func test_shield_damage():
	stats.shield = 10
	stats.take_damage(5)
	assert_eq(stats.shield, 5)

func test_shield_health():
	stats.shield = 10
	stats.take_damage(5)
	assert_eq(stats.health, 100)

func test_armor_damage():
	stats.armor = 2
	stats.take_damage(10)
	assert_eq(stats.health, 92)

func test_armor_remains():
	stats.armor = 2
	stats.take_damage(10)
	stats.take_damage(10)
	assert_eq(stats.health, 84)

func test_armor_exact_block_damage():
	stats.armor = 5
	stats.take_damage(5)
	assert_eq(stats.health, 100)

func test_armor_overblock_damage():
	stats.health = 90
	stats.armor = 10
	stats.take_damage(5)
	assert_eq(stats.health, 90)

func test_shield_armor_damage():
	stats.shield = 10
	stats.armor = 2
	stats.take_damage(5)
	assert_eq(stats.shield, 7)

func test_shield_exact_break_signal():
	watch_signals(stats)
	stats.shield = 10
	stats.take_damage(10)
	assert_signal_emitted(stats, 'shield_broke')

func test_shield_overkill_break_signal():
	watch_signals(stats)
	stats.shield = 10
	stats.take_damage(15)
	assert_signal_emitted(stats, 'shield_broke')

func test_shield_overkill_damage():
	stats.shield = 10
	stats.take_damage(15)
	assert_eq(stats.health, 95)
	
func test_shield_armor_exact_damage():
	stats.shield = 10
	stats.armor = 2
	stats.take_damage(12)
	assert_eq(stats.health, 100)
	
func test_shield_armor_overkill_damage():
	stats.shield = 10
	stats.armor = 2
	stats.take_damage(13)
	assert_eq(stats.health, 99)

func test_dodges():
	stats.dodges = 1
	stats.take_damage(100)
	assert_eq(stats.health, 100)

func test_dodges_used():
	stats.dodges = 1
	stats.take_damage(10)
	stats.take_damage(10)
	assert_eq(stats.health, 90)

func test_dodged_signal():
	watch_signals(stats)
	stats.dodges = 1
	stats.take_damage(100)
	assert_signal_emitted(stats, 'dodged')
	
func test_percent_damage():
	stats.take_percent_damage(0.5)
	assert_eq(stats.health, 50)
	
func test_percent_rounding():
	stats.take_percent_damage(0.509)
	assert_eq(stats.health, 50)
	
func test_ignore_shield():
	stats.shield = 20
	stats.take_damage(10, true, false, false)
	assert_eq(stats.health, 90)
	
func test_ignore_armor():
	stats.armor = 4
	stats.take_damage(10, false, true, false)
	assert_eq(stats.health, 90)
	
func test_ignore_dodges():
	stats.dodges = 2
	stats.take_damage(10, false, false, true)
	assert_eq(stats.health, 90)
	
func test_shield_factor_shield_damage():
	stats.shield = 30
	stats.take_damage(10, false, false, false, 2.0)
	assert_eq(stats.shield, 10)
	
func test_shield_factor_health_damage():
	stats.shield = 10
	stats.take_damage(10, false, false, false, 2.0)
	assert_eq(stats.health, 95)
	
func test_shield_factor_rounding():
	stats.shield = 10
	stats.take_damage(5, false, false, false, 1.9)
	assert_eq(stats.shield, 1)
	
func test_hit_signal():
	watch_signals(stats)
	stats.take_damage(10)
	assert_signal_emitted(stats, 'hit')
	
func test_hit_signal_armor():
	watch_signals(stats)
	stats.armor = 1
	stats.take_damage(1)
	assert_signal_emitted(stats, 'hit')
	
func test_hit_signal_shield():
	watch_signals(stats)
	stats.shield = 10
	stats.take_damage(10)
	assert_signal_not_emitted(stats, 'hit')
	
func test_hit_signal_dodged():
	watch_signals(stats)
	stats.dodges = 1
	stats.take_damage(10)
	assert_signal_not_emitted(stats, 'hit')
	
func test_made_contact_signal_health():
	watch_signals(stats)
	stats.take_damage(10)
	assert_signal_emitted(stats, 'made_contact')
	
func test_made_contact_signal_armor():
	watch_signals(stats)
	stats.armor = 1
	stats.take_damage(1)
	assert_signal_emitted(stats, 'made_contact')
	
func test_made_contact_signal_shield():
	watch_signals(stats)
	stats.shield = 10
	stats.take_damage(10)
	assert_signal_emitted(stats, 'made_contact')
	
func test_exact_death_dies():
	watch_signals(stats)
	stats.take_damage(100)
	assert_signal_emitted(stats, 'died')

func test_overkill_dies():
	watch_signals(stats)
	stats.take_damage(1000)
	assert_signal_emitted(stats, 'died')

func test_max_health_cap():
	stats.max_health = 90
	assert_eq(stats.health, 90)

## Pruebas de valores base e iniciales
func test_health_setup():
	stats.max_health = 110
	stats.setup()
	assert_eq(stats.health, 110)

func test_base_strength_setup():
	stats.base_strength = 1
	stats.setup()
	assert_eq(stats.strength, 1)

func test_base_shield_setup():
	stats.base_shield = 1
	stats.setup()
	assert_eq(stats.shield, 1)
	
func test_base_armor_setup():
	stats.base_armor = 1
	stats.setup()
	assert_eq(stats.armor, 1)

func test_base_dodges_setup():
	stats.base_dodges = 1
	stats.setup()
	assert_eq(stats.dodges, 1)

func test_base_strength_start_battle():
	stats.base_strength = 1
	stats.start_battle()
	assert_eq(stats.strength, 1)

func test_base_shield_start_battle():
	stats.base_shield = 1
	stats.start_battle()
	assert_eq(stats.shield, 1)

func test_base_armor_start_battle():
	stats.base_armor = 1
	stats.start_battle()
	assert_eq(stats.armor, 1)

func test_base_dodges_start_battle():
	stats.base_dodges = 1
	stats.start_battle()
	assert_eq(stats.dodges, 1)

## Pruebas de señales de cambio
func test_max_health_changed():
	watch_signals(stats)
	stats.max_health = 90
	assert_signal_emitted_with_parameters(stats, 'max_health_changed', [100, 90])
	
func test_health_changed():
	watch_signals(stats)
	stats.health = 90
	assert_signal_emitted_with_parameters(stats, 'health_changed', [100, 90, 100])

func test_strength_changed():
	watch_signals(stats)
	stats.strength = 1
	assert_signal_emitted_with_parameters(stats, 'strength_changed', [0, 1])

func test_shield_changed():
	watch_signals(stats)
	stats.shield = 1
	assert_signal_emitted_with_parameters(stats, 'shield_changed', [0, 1])
	
func test_armor_changed():
	watch_signals(stats)
	stats.armor = 1
	assert_signal_emitted_with_parameters(stats, 'armor_changed', [0, 1])

func test_dodges_changed():
	watch_signals(stats)
	stats.dodges = 1
	assert_signal_emitted_with_parameters(stats, 'dodges_changed', [0, 1])
