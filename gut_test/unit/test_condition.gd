extends GutTest

var condition: Condition
var player: Player
var enemy: Enemy
const DEFAULT_COIN = preload("res://Battle/coin_ui/resources/default_coin.tres")

func before_each():
	player = Player.new()
	player.stats = PlayerStats.new(100)
	enemy = Enemy.new()
	enemy.stats = EnemyStats.new(100)
	
func after_each():
	for coin in player.coins:
		coin.queue_free()
	player.queue_free()
	enemy.queue_free()
	
## EventCondition
func test_event_met_signal():
	condition = EventCondition.new()
	watch_signals(condition)
	condition.connect_to(player)
	condition._on_met()
	assert_signal_emitted(condition, 'met')

func test_event_remaining():
	condition = EventCondition.new()
	condition.amount = 3
	condition.connect_to(player)
	condition._check_met()
	assert_eq(condition.remaining, 2)
	
func test_event_remaining_signal():
	condition = EventCondition.new()
	watch_signals(condition)
	condition.amount = 3
	condition.connect_to(player)
	condition._check_met()
	assert_signal_emitted_with_parameters(condition, 'remaining_changed', [3, 2])
	
func test_event_check_met_amount():
	condition = EventCondition.new()
	watch_signals(condition)
	condition.amount = 2
	condition.connect_to(player)
	condition._check_met()
	condition._check_met()
	assert_signal_emitted(condition, 'met')

func test_event_check_met_not_enough():
	condition = EventCondition.new()
	watch_signals(condition)
	condition.amount = 2
	condition.connect_to(player)
	condition._check_met()
	assert_signal_not_emitted(condition, 'met')

## CoinDroppedCondition
func test_coin_dropped():
	condition = CoinDroppedCondition.new()
	watch_signals(condition)
	condition.connect_to(player)
	var coin: Coin = DEFAULT_COIN.create_coin_instance()
	player.coin_dropped.emit(coin)
	assert_signal_emitted(condition, 'met')
	coin.queue_free()

func test_coin_dropped_heads_facing_correct():
	condition = CoinDroppedCondition.new()
	condition.facing = Coin.Facing.HEADS
	watch_signals(condition)
	condition.connect_to(player)
	var coin: Coin = DEFAULT_COIN.create_coin_instance()
	coin.heads = true
	player.coin_dropped.emit(coin)
	assert_signal_emitted(condition, 'met')
	coin.queue_free()

func test_coin_dropped_heads_facing_wrong():
	condition = CoinDroppedCondition.new()
	condition.facing = Coin.Facing.TAILS
	watch_signals(condition)
	condition.connect_to(player)
	var coin: Coin = DEFAULT_COIN.create_coin_instance()
	coin.heads = true
	player.coin_dropped.emit(coin)
	assert_signal_not_emitted(condition, 'met')
	coin.queue_free()

func test_coin_dropped_tails_facing_correct():
	condition = CoinDroppedCondition.new()
	condition.facing = Coin.Facing.TAILS
	watch_signals(condition)
	condition.connect_to(player)
	var coin: Coin = DEFAULT_COIN.create_coin_instance()
	coin.heads = false
	player.coin_dropped.emit(coin)
	assert_signal_emitted(condition, 'met')
	coin.queue_free()

func test_coin_dropped_tails_facing_wrong():
	condition = CoinDroppedCondition.new()
	condition.facing = Coin.Facing.TAILS
	watch_signals(condition)
	condition.connect_to(player)
	var coin: Coin = DEFAULT_COIN.create_coin_instance()
	coin.heads = true
	player.coin_dropped.emit(coin)
	assert_signal_not_emitted(condition, 'met')
	coin.queue_free()

## FlipCondition
func test_flip():
	condition = FlipCondition.new()
	watch_signals(condition)
	condition.connect_to(player)
	var coin: Coin = DEFAULT_COIN.create_coin_instance()
	player.coin_flipped.emit(coin)
	assert_signal_emitted(condition, 'met')
	coin.queue_free()
	
func test_flip_heads_facing_correct():
	condition = FlipCondition.new()
	condition.facing = Coin.Facing.HEADS
	watch_signals(condition)
	condition.connect_to(player)
	var coin: Coin = DEFAULT_COIN.create_coin_instance()
	coin.heads = true
	player.coin_flipped.emit(coin)
	assert_signal_emitted(condition, 'met')
	coin.queue_free()

func test_flip_heads_facing_wrong():
	condition = FlipCondition.new()
	condition.facing = Coin.Facing.TAILS
	watch_signals(condition)
	condition.connect_to(player)
	var coin: Coin = DEFAULT_COIN.create_coin_instance()
	coin.heads = true
	player.coin_flipped.emit(coin)
	assert_signal_not_emitted(condition, 'met')
	coin.queue_free()

func test_flip_tails_facing_correct():
	condition = FlipCondition.new()
	condition.facing = Coin.Facing.TAILS
	watch_signals(condition)
	condition.connect_to(player)
	var coin: Coin = DEFAULT_COIN.create_coin_instance()
	coin.heads = false
	player.coin_flipped.emit(coin)
	assert_signal_emitted(condition, 'met')
	coin.queue_free()

func test_flip_tails_facing_wrong():
	condition = FlipCondition.new()
	condition.facing = Coin.Facing.TAILS
	watch_signals(condition)
	condition.connect_to(player)
	var coin: Coin = DEFAULT_COIN.create_coin_instance()
	coin.heads = true
	player.coin_flipped.emit(coin)
	assert_signal_not_emitted(condition, 'met')
	coin.queue_free()
	
## HitCondition
func test_hit():
	condition = HitCondition.new()
	watch_signals(condition)
	condition.connect_to(player)
	player.get_stats().hit.emit()
	assert_signal_emitted(condition, 'met')

func test_hit_enemy():
	condition = HitCondition.new()
	watch_signals(condition)
	condition.connect_to(enemy)
	enemy.get_stats().hit.emit()
	assert_signal_emitted(condition, 'met')

func test_hit_over_threshold():
	condition = HitCondition.new()
	condition.min_damage_threshold = 5
	watch_signals(condition)
	condition.connect_to(player)
	player.get_stats().hit.emit(5)
	assert_signal_emitted(condition, 'met')

func test_hit_under_threshold():
	condition = HitCondition.new()
	condition.min_damage_threshold = 5
	watch_signals(condition)
	condition.connect_to(player)
	player.get_stats().hit.emit(4)
	assert_signal_not_emitted(condition, 'met')

## ShieldBreakCondition
func test_shield_break():
	condition = ShieldBreakCondition.new()
	watch_signals(condition)
	condition.connect_to(player)
	player.get_stats().shield_broke.emit()
	assert_signal_emitted(condition, 'met')
	
func test_shield_break_enemy():
	condition = ShieldBreakCondition.new()
	watch_signals(condition)
	condition.connect_to(enemy)
	enemy.get_stats().shield_broke.emit()
	assert_signal_emitted(condition, 'met')

## StartOfBattleCondition
func test_start_of_battle():
	condition = StartOfBattleCondition.new()
	watch_signals(condition)
	condition.connect_to(player)
	player.started_battle.emit()
	assert_signal_emitted(condition, 'met')

func test_start_of_battle_enemy():
	condition = StartOfBattleCondition.new()
	watch_signals(condition)
	condition.connect_to(enemy)
	enemy.started_battle.emit()
	assert_signal_emitted(condition, 'met')

## StartOfTurnCondition
func test_start_of_turn():
	condition = StartOfTurnCondition.new()
	condition.at_beginning = false
	watch_signals(condition)
	condition.connect_to(player)
	player.started_turn.emit()
	assert_signal_emitted(condition, 'met')

func test_start_of_turn_enemy():
	condition = StartOfTurnCondition.new()
	condition.at_beginning = false
	watch_signals(condition)
	condition.connect_to(enemy)
	enemy.started_turn.emit()
	assert_signal_emitted(condition, 'met')
	
func test_pre_start_of_turn():
	condition = StartOfTurnCondition.new()
	condition.at_beginning = true
	watch_signals(condition)
	condition.connect_to(player)
	player.pre_started_turn.emit()
	assert_signal_emitted(condition, 'met')

func test_pre_start_of_turn_enemy():
	condition = StartOfTurnCondition.new()
	condition.at_beginning = true
	watch_signals(condition)
	condition.connect_to(enemy)
	enemy.pre_started_turn.emit()
	assert_signal_emitted(condition, 'met')

## TurnFinishedCondition
func test_turn_finished():
	condition = TurnFinishedCondition.new()
	watch_signals(condition)
	condition.connect_to(player)
	player.turn_finished.emit()
	assert_signal_emitted(condition, 'met')
	
func test_turn_finished_enemy():
	condition = TurnFinishedCondition.new()
	watch_signals(condition)
	condition.connect_to(enemy)
	enemy.turn_finished.emit()
	assert_signal_emitted(condition, 'met')

## StateCondition

# Parámetros de prueba, [operador, valor, objetivo]
var operator_fitting_value = [
	[StateCondition.Operator.LOWER_THAN, 1, 2], 
	[StateCondition.Operator.LOWER_OR_EQUAL, 1, 2],
	[StateCondition.Operator.LOWER_OR_EQUAL, 2, 2], 
	[StateCondition.Operator.EQUAL, 2, 2],
	[StateCondition.Operator.GREATER_OR_EQUAL, 2, 2],
	[StateCondition.Operator.GREATER_OR_EQUAL, 3, 2],
	[StateCondition.Operator.GREATER_THAN, 3, 2],
	]

# Parámetros de prueba, [operador, valor, objetivo]
var operator_unfitting_value = [
	[StateCondition.Operator.LOWER_THAN, 2, 1], 
	[StateCondition.Operator.LOWER_THAN, 2, 2],
	[StateCondition.Operator.LOWER_OR_EQUAL, 2, 1], 
	[StateCondition.Operator.EQUAL, 1, 2],
	[StateCondition.Operator.GREATER_OR_EQUAL, 1, 2],
	[StateCondition.Operator.GREATER_THAN, 2, 2],
	[StateCondition.Operator.GREATER_THAN, 2, 3],
]

## HasArmorCondition
func test_has_armor(params=use_parameters(operator_fitting_value)):
	condition = HasArmorCondition.new()
	watch_signals(condition)
	condition.operator = params[0]
	condition.target = params[2]
	condition.connect_to(player)
	#player.get_stats().armor_changed.emit(0, params[1])
	player.get_stats().armor = params[1]
	assert_signal_emitted_with_parameters(condition, 'state_changed', [condition, true])

func test_has_armor_unfit(params=use_parameters(operator_unfitting_value)):
	condition = HasArmorCondition.new()
	watch_signals(condition)
	condition.operator = params[0]
	condition.target = params[2]
	condition.connect_to(player)
	#player.get_stats().armor_changed.emit(0, params[1])
	player.get_stats().armor = params[1]
	assert_signal_emitted_with_parameters(condition, 'state_changed', [condition, false])

## HasShieldCondition
func test_has_shield(params=use_parameters(operator_fitting_value)):
	condition = HasShieldCondition.new()
	watch_signals(condition)
	condition.operator = params[0]
	condition.target = params[2]
	condition.connect_to(player)
	#player.get_stats().shield_changed.emit(0, params[1])
	player.get_stats().shield = params[1]
	assert_signal_emitted_with_parameters(condition, 'state_changed', [condition, true])

func test_has_shield_unfit(params=use_parameters(operator_unfitting_value)):
	condition = HasShieldCondition.new()
	watch_signals(condition)
	condition.operator = params[0]
	condition.target = params[2]
	condition.connect_to(player)
	#player.get_stats().shield_changed.emit(0, params[1])
	player.get_stats().shield = params[1]
	assert_signal_emitted_with_parameters(condition, 'state_changed', [condition, false])

## InBattleCondition
func test_in_battle():
	condition = InBattleCondition.new()
	watch_signals(condition)
	condition.connect_to(player)
	player.started_battle.emit()
	assert_signal_emitted_with_parameters(condition, 'state_changed', [condition, true])

func test_out_of_battle():
	condition = InBattleCondition.new()
	watch_signals(condition)
	condition.connect_to(player)
	player.ended_battle.emit()
	assert_signal_emitted_with_parameters(condition, 'state_changed', [condition, false])

# Parámetros de prueba, [operador, valor, objetivo]
var percent_operator_fitting_value = [
	[StateCondition.Operator.LOWER_THAN, 20, 0.4], 
	[StateCondition.Operator.LOWER_OR_EQUAL, 40, 0.5],
	[StateCondition.Operator.LOWER_OR_EQUAL, 50, 0.5], 
	[StateCondition.Operator.EQUAL, 50, 0.5],
	[StateCondition.Operator.GREATER_OR_EQUAL, 50, 0.5],
	[StateCondition.Operator.GREATER_OR_EQUAL, 60, 0.5],
	[StateCondition.Operator.GREATER_THAN, 70, 0.6],
	]

# Parámetros de prueba, [operador, valor, porcentaje]
var percent_operator_unfitting_value = [
	[StateCondition.Operator.LOWER_THAN, 50, 0.4], 
	[StateCondition.Operator.LOWER_THAN, 50, 0.5],
	[StateCondition.Operator.LOWER_OR_EQUAL, 60, 0.5], 
	[StateCondition.Operator.EQUAL, 60, 0.5],
	[StateCondition.Operator.GREATER_OR_EQUAL, 40, 0.5],
	[StateCondition.Operator.GREATER_THAN, 50, 0.5],
	[StateCondition.Operator.GREATER_THAN, 40, 0.6],
]

## PercentHealthCondition
func test_percent_health(params=use_parameters(percent_operator_fitting_value)):
	condition = PercentHealthCondition.new()
	watch_signals(condition)
	condition.operator = params[0]
	condition.percent = params[2]
	condition.connect_to(player)
	#player.get_stats().health_changed.emit(0, params[1])
	player.get_stats().health = params[1]
	assert_signal_emitted_with_parameters(condition, 'state_changed', [condition, true])

func test_percent_health_unfit(params=use_parameters(percent_operator_unfitting_value)):
	condition = PercentHealthCondition.new()
	watch_signals(condition)
	condition.operator = params[0]
	condition.percent = params[2]
	condition.connect_to(player)
	#player.get_stats().health_changed.emit(0, params[1])
	player.get_stats().health = params[1]
	assert_signal_emitted_with_parameters(condition, 'state_changed', [condition, false])
