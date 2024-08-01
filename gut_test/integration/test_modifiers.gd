extends GutTest

var modifier: Modifier
var player: Player
var enemy: Enemy
const DEFAULT_COIN = preload("res://Battle/coin_ui/resources/default_coin.tres")


func before_each():
	player = Player.new()
	enemy = Enemy.new()
	player.stats = PlayerStats.new(100)
	var player_stats: PlayerStats = player.get_stats()
	enemy.stats = EnemyStats.new(100)

func after_each():
	for coin in player.coins:
		coin.queue_free()
	player.queue_free()
	enemy.queue_free()

## Modifier base
func test_modifier_finished():
	modifier = Modifier.new()
	watch_signals(modifier)
	modifier.apply_to(player)
	assert_signal_emitted(modifier, 'finished')

## BiasModifier
func test_bias_heads():
	modifier = BiasModifier.new()
	modifier.facing = Coin.Facing.HEADS
	modifier.count = 3
	modifier.apply_to(player)
	assert_eq(
		player.bias_list.all(func (x): return x == Coin.Facing.HEADS), true)

func test_bias_tails():
	modifier = BiasModifier.new()
	modifier.facing = Coin.Facing.TAILS
	modifier.count = 3
	modifier.apply_to(player)
	assert_eq(
		player.bias_list.all(func (x): return x == Coin.Facing.TAILS), true)

func test_bias_undo():
	player.bias_list = [Coin.Facing.TAILS]
	modifier = BiasModifier.new()
	modifier.facing = Coin.Facing.HEADS
	modifier.count = 3
	modifier.apply_to(player)
	modifier.undo_from(player)
	assert_eq(player.bias_list, [Coin.Facing.TAILS])

func test_bias_finished():
	modifier = BiasModifier.new()
	watch_signals(modifier)
	modifier.facing = Coin.Facing.HEADS
	modifier.count = 3
	modifier.apply_to(player)
	assert_signal_emitted(modifier, 'finished')
	
## CoinCountModifier
func test_coin_count():
	player.get_stats().coin_count = 5
	modifier = CoinCountModifier.new()
	modifier.coin_count = 1
	modifier.apply_to(player)
	assert_eq(player.get_stats().coin_count, 6)

func test_coin_count_undo():
	player.get_stats().coin_count = 5
	modifier = CoinCountModifier.new()
	modifier.coin_count = 1
	modifier.apply_to(player)
	modifier.undo_from(player)
	assert_eq(player.get_stats().coin_count, 5)

func test_coin_count_finished():
	player.get_stats().coin_count = 5
	modifier = CoinCountModifier.new()
	watch_signals(modifier)
	modifier.coin_count = 1
	modifier.apply_to(player)
	assert_signal_emitted(modifier, 'finished')

## CoinDropModifier
func test_coin_drop():
	player.coins = [DEFAULT_COIN.create_coin_instance()]
	modifier = CoinDropModifier.new()
	modifier.drop_count = 1
	modifier.apply_to(player)
	assert_eq(player.coins[0].status, Coin.Status.DROPPED)

func test_coin_drop_overflow():
	player.coins = [DEFAULT_COIN.create_coin_instance()]
	modifier = CoinDropModifier.new()
	modifier.drop_count = 3
	modifier.apply_to(player)
	assert_eq(player.coins[0].status, Coin.Status.DROPPED)

func test_coin_drop_heads_priority():
	var coins: Array[Coin] = []
	coins.resize(3)
	coins.fill(DEFAULT_COIN.create_coin_instance())
	coins[0].heads = false
	coins[2].heads = false
	player.coins = coins
	modifier = CoinDropModifier.new()
	modifier.facing = Coin.Facing.HEADS
	modifier.drop_count = 1
	modifier.apply_to(player)
	assert_eq(player.coins[1].status, Coin.Status.DROPPED)

func test_coin_drop_tails_priority():
	var coins: Array[Coin] = []
	coins.resize(3)
	coins.fill(DEFAULT_COIN.create_coin_instance())
	coins[1].heads = false
	player.coins = coins
	modifier = CoinDropModifier.new()
	modifier.facing = Coin.Facing.HEADS
	modifier.drop_count = 1
	modifier.apply_to(player)
	assert_eq(player.coins[1].status, Coin.Status.DROPPED)

func test_coin_drop_signal():
	player.coins = [DEFAULT_COIN.create_coin_instance()]
	watch_signals(player.coins[0])
	modifier = CoinDropModifier.new()
	modifier.drop_count = 1
	modifier.apply_to(player)
	assert_signal_emitted(player.coins[0], 'dropped')

func test_coin_drop_finished():
	player.coins = [DEFAULT_COIN.create_coin_instance()]
	modifier = CoinDropModifier.new()
	watch_signals(modifier)
	modifier.drop_count = 1
	modifier.apply_to(player)
	assert_signal_emitted(modifier, 'finished')

##ExtraCoinModifier
func test_extra_coin():
	modifier = ExtraCoinModifier.new()
	player.coins = [DEFAULT_COIN.create_coin_instance()]
	modifier.coin_data_list.append(DEFAULT_COIN)
	modifier.coin_data_list.append(DEFAULT_COIN)
	modifier.facing = Coin.Facing.ANY
	modifier.apply_to(player)
	assert_eq(player.coins.size(), 3)

func test_extra_coin_flip():
	modifier = ExtraCoinModifier.new()
	watch_signals(player)
	player.coins = []
	modifier.coin_data_list.append(DEFAULT_COIN)
	modifier.coin_data_list.append(DEFAULT_COIN)
	modifier.facing = Coin.Facing.ANY
	modifier.apply_to(player)
	assert_signal_emit_count(player, 'coin_flipped', 2)
	
func test_extra_coin_heads():
	modifier = ExtraCoinModifier.new()
	player.coins = []
	modifier.coin_data_list.append(DEFAULT_COIN)
	modifier.coin_data_list.append(DEFAULT_COIN)
	modifier.facing = Coin.Facing.HEADS
	modifier.apply_to(player)
	assert_eq(player.coins.all(func (x): return x.heads), true)

func test_extra_coin_tails():
	modifier = ExtraCoinModifier.new()
	player.coins = []
	modifier.coin_data_list.append(DEFAULT_COIN)
	modifier.coin_data_list.append(DEFAULT_COIN)
	modifier.facing = Coin.Facing.TAILS
	modifier.apply_to(player)
	assert_eq(player.coins.all(func (x): return !x.heads), true)

func test_extra_coin_finished():
	modifier = ExtraCoinModifier.new()
	watch_signals(modifier)
	player.coins = []
	modifier.coin_data_list.append(DEFAULT_COIN)
	modifier.coin_data_list.append(DEFAULT_COIN)
	modifier.facing = Coin.Facing.ANY
	modifier.apply_to(player)
	assert_signal_emitted(modifier, 'finished')

## Modificadores de estadísticas

# Pruebas con parámetros, [acción, magnitud, resultado esperado]
var action_magnitude_result = [
	[StatModifier.Action.ADD, 10, 12], 
	[StatModifier.Action.MULT, 10, 20], 
	[StatModifier.Action.SET, 10, 10]
	]

func test_parameters_base_armor(params=use_parameters(action_magnitude_result)):
	player.get_stats().base_armor = 2
	modifier = BaseArmorModifier.new()
	modifier.action = params[0]
	modifier.magnitude = params[1]
	modifier.apply_to(player)
	assert_eq(player.get_stats().base_armor, params[2])

func test_base_armor_finished(params=use_parameters(action_magnitude_result)):
	player.get_stats().base_armor = 2
	modifier = BaseArmorModifier.new()
	watch_signals(modifier)
	modifier.action = params[0]
	modifier.magnitude = params[1]
	modifier.apply_to(player)
	assert_signal_emitted(modifier, 'finished')

func test_parameters_base_dodges(params=use_parameters(action_magnitude_result)):
	player.get_stats().base_dodges = 2
	modifier = BaseDodgesModifier.new()
	modifier.action = params[0]
	modifier.magnitude = params[1]
	modifier.apply_to(player)
	assert_eq(player.get_stats().base_dodges, params[2])

func test_base_dodges_finished(params=use_parameters(action_magnitude_result)):
	player.get_stats().base_dodges = 2
	modifier = BaseDodgesModifier.new()
	watch_signals(modifier)
	modifier.action = params[0]
	modifier.magnitude = params[1]
	modifier.apply_to(player)
	assert_signal_emitted(modifier, 'finished')

func test_parameters_base_shield(params=use_parameters(action_magnitude_result)):
	player.get_stats().base_shield = 2
	modifier = BaseShieldModifier.new()
	modifier.action = params[0]
	modifier.magnitude = params[1]
	modifier.apply_to(player)
	assert_eq(player.get_stats().base_shield, params[2])


func test_base_shield_finished(params=use_parameters(action_magnitude_result)):
	player.get_stats().base_shield = 2
	modifier = BaseShieldModifier.new()
	watch_signals(modifier)
	modifier.action = params[0]
	modifier.magnitude = params[1]
	modifier.apply_to(player)
	assert_signal_emitted(modifier, 'finished')

func test_parameters_base_strength(params=use_parameters(action_magnitude_result)):
	player.get_stats().base_strength = 2
	modifier = BaseStrengthModifier.new()
	modifier.action = params[0]
	modifier.magnitude = params[1]
	modifier.apply_to(player)
	assert_eq(player.get_stats().base_strength, params[2])

func test_base_strength_finished(params=use_parameters(action_magnitude_result)):
	player.get_stats().base_strength = 2
	modifier = BaseStrengthModifier.new()
	watch_signals(modifier)
	modifier.action = params[0]
	modifier.magnitude = params[1]
	modifier.apply_to(player)
	assert_signal_emitted(modifier, 'finished')

func test_parameters_armor(params=use_parameters(action_magnitude_result)):
	player.get_stats().armor = 2
	modifier = ArmorModifier.new()
	modifier.action = params[0]
	modifier.magnitude = params[1]
	modifier.apply_to(player)
	assert_eq(player.get_stats().armor, params[2])

func test_armor_finished(params=use_parameters(action_magnitude_result)):
	player.get_stats().armor = 2
	modifier = ArmorModifier.new()
	watch_signals(modifier)
	modifier.action = params[0]
	modifier.magnitude = params[1]
	modifier.apply_to(player)
	assert_signal_emitted(modifier, 'finished')

func test_parameters_dodges(params=use_parameters(action_magnitude_result)):
	player.get_stats().dodges = 2
	modifier = DodgesModifier.new()
	modifier.action = params[0]
	modifier.magnitude = params[1]
	modifier.apply_to(player)
	assert_eq(player.get_stats().dodges, params[2])

func test_dodges_finished(params=use_parameters(action_magnitude_result)):
	player.get_stats().dodges = 2
	modifier = DodgesModifier.new()
	watch_signals(modifier)
	modifier.action = params[0]
	modifier.magnitude = params[1]
	modifier.apply_to(player)
	assert_signal_emitted(modifier, 'finished')

func test_parameters_shield(params=use_parameters(action_magnitude_result)):
	player.get_stats().shield = 2
	modifier = ShieldModifier.new()
	modifier.action = params[0]
	modifier.magnitude = params[1]
	modifier.apply_to(player)
	assert_eq(player.get_stats().shield, params[2])

func test_shield_finished(params=use_parameters(action_magnitude_result)):
	player.get_stats().shield = 2
	modifier = ShieldModifier.new()
	watch_signals(modifier)
	modifier.action = params[0]
	modifier.magnitude = params[1]
	modifier.apply_to(player)
	assert_signal_emitted(modifier, 'finished')

func test_parameters_strength(params=use_parameters(action_magnitude_result)):
	player.get_stats().strength = 2
	modifier = StrengthModifier.new()
	modifier.action = params[0]
	modifier.magnitude = params[1]
	modifier.apply_to(player)
	assert_eq(player.get_stats().strength, params[2])

func test_strength_finished(params=use_parameters(action_magnitude_result)):
	player.get_stats().strength = 2
	modifier = StrengthModifier.new()
	watch_signals(modifier)
	modifier.action = params[0]
	modifier.magnitude = params[1]
	modifier.apply_to(player)
	assert_signal_emitted(modifier, 'finished')

func test_parameters_health(params=use_parameters(action_magnitude_result)):
	player.get_stats().health = 2
	modifier = HealthModifier.new()
	modifier.action = params[0]
	modifier.magnitude = params[1]
	modifier.apply_to(player)
	assert_eq(player.get_stats().health, params[2])

func test_health_finished(params=use_parameters(action_magnitude_result)):
	player.get_stats().health = 2
	modifier = HealthModifier.new()
	watch_signals(modifier)
	modifier.action = params[0]
	modifier.magnitude = params[1]
	modifier.apply_to(player)
	assert_signal_emitted(modifier, 'finished')

func test_parameters_max_health(params=use_parameters(action_magnitude_result)):
	player.get_stats().max_health = 2
	modifier = MaxHealthModifier.new()
	modifier.action = params[0]
	modifier.magnitude = params[1]
	modifier.apply_to(player)
	assert_eq(player.get_stats().max_health, params[2])

func test_max_health_finished(params=use_parameters(action_magnitude_result)):
	player.get_stats().max_health = 2
	modifier = MaxHealthModifier.new()
	watch_signals(modifier)
	modifier.action = params[0]
	modifier.magnitude = params[1]
	modifier.apply_to(player)
	assert_signal_emitted(modifier, 'finished')

func test_max_health_health_cap():
	modifier = MaxHealthModifier.new()
	modifier.action = StatModifier.Action.ADD
	modifier.magnitude = -10
	modifier.apply_to(player)
	assert_eq(player.get_stats().health, 90)

var luck_parameters = [
	[StatModifier.Action.ADD, 0.05, 0.55], 
	[StatModifier.Action.MULT, 1.2, 0.6], 
	[StatModifier.Action.SET, 0.7, 0.7]
	]

func test_parameters_luck(params=use_parameters(luck_parameters)):
	player.get_stats().base_luck = 0.5
	modifier = LuckModifier.new()
	modifier.action = params[0]
	modifier.magnitude = params[1]
	modifier.apply_to(player)
	assert_eq(player.get_stats().base_luck, params[2])

func test_luck_finished(params=use_parameters(luck_parameters)):
	player.get_stats().base_luck = 0.5
	modifier = LuckModifier.new()
	watch_signals(modifier)
	modifier.action = params[0]
	modifier.magnitude = params[1]
	modifier.apply_to(player)
	assert_signal_emitted(modifier, 'finished')

## Modificadores para enemigos

## NextSkillModifier
func test_enemy_next_skill():
	modifier = NextSkillModifier.new()
	var skill1: SkillData = SkillData.new()
	var skill2: SkillData = SkillData.new()
	enemy.upcoming_skills.append(skill1)
	modifier.skill = skill2
	modifier.apply_to(enemy)
	assert_eq(enemy.upcoming_skills, [skill2, skill1])

func test_enemy_next_skill_replace():
	modifier = NextSkillModifier.new()
	var skill1: SkillData = SkillData.new()
	var skill2: SkillData = SkillData.new()
	enemy.upcoming_skills.append(skill1)
	modifier.skill = skill2
	modifier.replace = true
	modifier.apply_to(enemy)
	assert_eq(enemy.upcoming_skills, [skill2])

func test_enemy_next_skill_finished():
	modifier = NextSkillModifier.new()
	watch_signals(modifier)
	var skill1: SkillData = SkillData.new()
	var skill2: SkillData = SkillData.new()
	enemy.upcoming_skills.append(skill1)
	modifier.skill = skill2
	modifier.apply_to(enemy)
	assert_signal_emitted(modifier, 'finished')

## SkillListModifier
func test_enemy_skill_list():
	modifier = SkillListModifier.new()
	var skill1: SkillData = SkillData.new()
	var skill2: SkillData = SkillData.new()
	var skill3: SkillData = SkillData.new()
	modifier.skill_list.append(skill1)
	modifier.skill_list.append(skill2)
	enemy.skills.append(skill3)
	modifier.apply_to(enemy)
	assert_eq(enemy.skills, [skill1, skill2])

func test_enemy_skill_list_available():
	modifier = SkillListModifier.new()
	var skill1: SkillData = SkillData.new()
	var skill2: SkillData = SkillData.new()
	var skill3: SkillData = SkillData.new()
	modifier.skill_list.append(skill1)
	modifier.skill_list.append(skill2)
	enemy.available_skills.append(skill3)
	modifier.apply_to(enemy)
	assert_eq(enemy.available_skills, [skill1, skill2])

func test_enemy_skill_list_strategy():
	modifier = SkillListModifier.new()
	var skill1: SkillData = SkillData.new()
	var skill2: SkillData = SkillData.new()
	var skill3: SkillData = SkillData.new()
	modifier.skill_list.append(skill1)
	modifier.skill_list.append(skill2)
	modifier.strategy = Enemy.Strategy.POP_RANDOM
	enemy.skills.append(skill3)
	enemy.strategy = Enemy.Strategy.PURE_RANDOM
	modifier.apply_to(enemy)
	assert_eq(enemy.strategy, Enemy.Strategy.POP_RANDOM)

func test_enemy_skill_list_finished():
	modifier = SkillListModifier.new()
	watch_signals(modifier)
	var skill1: SkillData = SkillData.new()
	var skill2: SkillData = SkillData.new()
	var skill3: SkillData = SkillData.new()
	modifier.skill_list.append(skill1)
	modifier.skill_list.append(skill2)
	enemy.skills.append(skill3)
	modifier.apply_to(enemy)
	assert_signal_emitted(modifier, 'finished')
