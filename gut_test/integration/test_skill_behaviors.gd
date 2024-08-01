extends GutTest

var behavior: SkillBehavior
var player: Player
var enemy: Enemy
var coins: Array[Coin]
const DEFAULT_COIN = preload("res://Battle/coin_ui/resources/default_coin.tres")

func before_each():
	player = Player.new()
	enemy = Enemy.new()
	player.stats = PlayerStats.new(100)
	enemy.stats = EnemyStats.new(100)
	var coin = DEFAULT_COIN.create_coin_instance()
	coins = [coin]
	
func after_each():
	for coin in player.coins:
		coin.queue_free()
	player.queue_free()
	enemy.queue_free()
	for coin in coins:
		coin.queue_free()

## SkillBehavior base
func test_finished():
	behavior = SkillBehavior.new()
	watch_signals(behavior)
	behavior.use(player, enemy, coins)
	assert_signal_emitted(behavior, 'finished')
	
## DamageSkillBehavior
func test_basic_damage():
	behavior = DamageSkillBehavior.new()
	behavior.damage = 10
	behavior.use(player, enemy, coins)
	assert_eq(enemy.get_stats().health, 90)

func test_basic_damage_enemy_to_player():
	behavior = DamageSkillBehavior.new()
	behavior.damage = 10
	behavior.use(enemy, player, coins)
	assert_eq(player.get_stats().health, 90)

func test_self_damage():
	behavior = DamageSkillBehavior.new()
	behavior.damage = 10
	behavior.to_self = true
	behavior.use(player, enemy, coins)
	assert_eq(player.get_stats().health, 90)

func test_strength_damage():
	behavior = DamageSkillBehavior.new()
	behavior.damage = 10
	player.get_stats().strength = 1
	behavior.use(player, enemy, coins)
	assert_eq(enemy.get_stats().health, 89)

func test_ignore_shield_damage():
	behavior = DamageSkillBehavior.new()
	behavior.damage = 10
	behavior.ignore_shield = true
	enemy.get_stats().shield = 10
	behavior.use(player, enemy, coins)
	assert_eq(enemy.get_stats().health, 90)
	
func test_ignore_armor_damage():
	behavior = DamageSkillBehavior.new()
	behavior.damage = 10
	behavior.ignore_armor = true
	enemy.get_stats().armor = 1
	behavior.use(player, enemy, coins)
	assert_eq(enemy.get_stats().health, 90)
	
func test_ignore_dodges_damage():
	behavior = DamageSkillBehavior.new()
	behavior.damage = 10
	behavior.ignore_dodges = true
	enemy.get_stats().dodges = 1
	behavior.use(player, enemy, coins)
	assert_eq(enemy.get_stats().health, 90)

func test_shield_factor_damage():
	behavior = DamageSkillBehavior.new()
	behavior.damage = 10
	behavior.shield_factor = 2.0
	enemy.get_stats().shield = 20
	behavior.use(player, enemy, coins)
	assert_eq(enemy.get_stats().shield, 0)
	
func test_damage_finished():
	behavior = DamageSkillBehavior.new()
	watch_signals(behavior)
	# Los tests no ejecutan la animación, por lo que se le tiene que dar
	# una nula para que finalice.
	behavior.animation_scene = null
	behavior.damage = 10
	behavior.use(player, enemy, coins)
	assert_signal_emitted(behavior, 'finished')

## DropUsedCoinSkillBehavior
func test_drop_used():
	var coin = DEFAULT_COIN.create_coin_instance()
	coins = [coin, coin, coin]
	behavior = DropUsedCoinsSkillBehavior.new()
	behavior.use(player, enemy, coins)
	assert_eq(coins.all(func (x: Coin): return x.status == Coin.Status.DROPPED), true)

## ExtraCoinSkillBehavior
func test_extra_coin_added():
	behavior = ExtraCoinSkillBehavior.new()
	player.coins = [DEFAULT_COIN.create_coin_instance()]
	behavior.ephemeral_coins = 2
	behavior.facing = Coin.Facing.ANY
	behavior.use(player, enemy, coins)
	assert_eq(player.coins.size(), 3)

func test_extra_coin_ephemeral():
	behavior = ExtraCoinSkillBehavior.new()
	player.coins = []
	behavior.ephemeral_coins = 2
	behavior.facing = Coin.Facing.ANY
	behavior.use(player, enemy, coins)
	assert_eq(player.coins.all(func (x: Coin): return x.is_ephemeral), true)
	
func test_extra_coin_any_flips():
	watch_signals(player)
	behavior = ExtraCoinSkillBehavior.new()
	player.coins = [DEFAULT_COIN.create_coin_instance()]
	behavior.ephemeral_coins = 2
	behavior.facing = Coin.Facing.ANY
	behavior.use(player, enemy, coins)
	assert_signal_emit_count(player, 'coin_flipped', 2)

func test_extra_coin_heads():
	behavior = ExtraCoinSkillBehavior.new()
	player.coins = []
	behavior.ephemeral_coins = 2
	behavior.facing = Coin.Facing.HEADS
	behavior.use(player, enemy, coins)
	assert_eq(player.coins.all(func (x: Coin): return x.heads), true)
	
func test_extra_coin_tails():
	behavior = ExtraCoinSkillBehavior.new()
	player.coins = []
	behavior.ephemeral_coins = 2
	behavior.facing = Coin.Facing.TAILS
	behavior.use(player, enemy, coins)
	assert_eq(player.coins.all(func (x: Coin): return !x.heads), true)

func test_extra_coin_finished():
	behavior = ExtraCoinSkillBehavior.new()
	watch_signals(behavior)
	player.coins = []
	behavior.ephemeral_coins = 2
	behavior.facing = Coin.Facing.ANY
	behavior.use(player, enemy, coins)
	assert_signal_emitted(behavior, 'finished')
	

## HealSkillBehavior
func test_heal_self():
	behavior = HealSkillBehavior.new()
	behavior.magnitude = 10
	behavior.to_self = true
	player.get_stats().health = 80
	behavior.use(player, enemy, coins)
	assert_eq(player.get_stats().health, 90)

func test_heal_target():
	behavior = HealSkillBehavior.new()
	behavior.magnitude = 10
	behavior.to_self = false
	player.get_stats().health = 80
	behavior.use(enemy, player, coins)
	assert_eq(player.get_stats().health, 90)

func test_overheal():
	behavior = HealSkillBehavior.new()
	behavior.magnitude = 10
	behavior.to_self = true
	player.get_stats().health = 95
	behavior.use(player, enemy, coins)
	assert_eq(player.get_stats().health, 100)

func test_heal_finished():
	behavior = HealSkillBehavior.new()
	watch_signals(behavior)
	behavior.magnitude = 10
	behavior.to_self = true
	player.get_stats().health = 80
	behavior.use(player, enemy, coins)
	assert_signal_emitted(behavior, 'finished')

## MultihitSkillBehavior
func test_multihit():
	behavior = MultihitSkillBehavior.new()
	behavior.animation_scene = null
	behavior.hits = 3
	behavior.damage = 10
	behavior.use(player, enemy, coins)
	assert_eq(enemy.get_stats().health, 70)

func test_multihit_strength():
	behavior = MultihitSkillBehavior.new()
	behavior.animation_scene = null
	behavior.hits = 3
	behavior.damage = 10
	enemy.get_stats().strength = 1
	behavior.use(enemy, player, coins)
	assert_eq(player.get_stats().health, 67)

func test_multihit_finished():
	behavior = MultihitSkillBehavior.new()
	watch_signals(behavior)
	behavior.animation_scene = null
	behavior.hits = 3
	behavior.damage = 10
	behavior.use(player, enemy, coins)
	assert_signal_emitted(behavior, 'finished')

## RemoveCoinSkillBehavior
func test_remove_coin():
	behavior = RemoveCoinSkillBehavior.new()
	behavior.magnitude = 1
	player.coins = [DEFAULT_COIN.create_coin_instance(), DEFAULT_COIN.create_coin_instance()]
	behavior.use(player, enemy, coins)
	assert_eq(player.coins.size(), 1)
	
func test_remove_used():
	behavior = RemoveCoinSkillBehavior.new()
	behavior.remove_all_used = true
	player.coins = [DEFAULT_COIN.create_coin_instance(), DEFAULT_COIN.create_coin_instance()]
	coins = player.coins.duplicate()
	behavior.use(player, enemy, coins)
	assert_eq(player.coins.size(), 0)

func test_remove_target():
	behavior = RemoveCoinSkillBehavior.new()
	behavior.magnitude = 1
	behavior.to_self = false
	player.coins = [DEFAULT_COIN.create_coin_instance(), DEFAULT_COIN.create_coin_instance()]
	behavior.use(enemy, player, coins)
	assert_eq(player.coins.size(), 1)

func test_remove_finished():
	behavior = RemoveCoinSkillBehavior.new()
	watch_signals(behavior)
	behavior.magnitude = 1
	player.coins = [DEFAULT_COIN.create_coin_instance(), DEFAULT_COIN.create_coin_instance()]
	behavior.use(player, enemy, coins)
	assert_signal_emitted(behavior, 'finished')
	
## RerollSkillBehavior
func test_reroll_flip():
	behavior = RerollSkillBehavior.new()
	behavior.rerolls = 1
	behavior.facing = Coin.Facing.ANY
	coins = [DEFAULT_COIN.create_coin_instance()]
	watch_signals(coins[0])
	behavior.use(player, enemy, coins)
	assert_signal_emitted(coins[0], 'flipped')
	
func test_reroll_heads():
	behavior = RerollSkillBehavior.new()
	player.coins = []
	behavior.rerolls = 2
	behavior.facing = Coin.Facing.HEADS
	coins = [DEFAULT_COIN.create_coin_instance(), DEFAULT_COIN.create_coin_instance()]
	behavior.use(player, enemy, coins)
	assert_eq(player.coins.all(func (x: Coin): return x.heads), true)

func test_reroll_tails():
	behavior = RerollSkillBehavior.new()
	player.coins = []
	behavior.rerolls = 2
	behavior.facing = Coin.Facing.TAILS
	coins = [DEFAULT_COIN.create_coin_instance(), DEFAULT_COIN.create_coin_instance()]
	behavior.use(player, enemy, coins)
	assert_eq(player.coins.all(func (x: Coin): return !x.heads), true)

func test_reroll_finished():
	behavior = RerollSkillBehavior.new()
	watch_signals(behavior)
	behavior.rerolls = 1
	behavior.facing = Coin.Facing.ANY
	coins = [DEFAULT_COIN.create_coin_instance()]
	watch_signals(coins[0])
	behavior.use(player, enemy, coins)
	assert_signal_emitted(behavior, 'finished')

## ShieldSkillBehavior
func test_shield():
	behavior = ShieldSkillBehavior.new()
	behavior.shield = 5
	behavior.use(player, enemy, coins)
	assert_eq(player.get_stats().shield, 5)

func test_shield_finished():
	behavior = ShieldSkillBehavior.new()
	watch_signals(behavior)
	behavior.shield = 5
	behavior.use(player, enemy, coins)
	assert_signal_emitted(behavior, 'finished')

## SplitSkillBehavior
func test_split_heads_do():
	behavior = SplitSkillBehavior.new()
	var damage_beh = DamageSkillBehavior.new()
	damage_beh.damage = 10
	var shield_beh = ShieldSkillBehavior.new()
	shield_beh.shield = 10
	var coin: Coin = DEFAULT_COIN.create_coin_instance()
	coin.heads = true
	behavior.heads_behaviors.append(damage_beh)
	behavior.tails_behaviors.append(shield_beh)
	coins = [coin]
	behavior.use(player, enemy, coins)
	assert_eq(enemy.get_stats().health, 90)

func test_split_heads_dont():
	behavior = SplitSkillBehavior.new()
	var damage_beh = DamageSkillBehavior.new()
	damage_beh.damage = 10
	var shield_beh = ShieldSkillBehavior.new()
	shield_beh.shield = 10
	var coin: Coin = DEFAULT_COIN.create_coin_instance()
	coin.heads = true
	behavior.heads_behaviors.append(damage_beh)
	behavior.tails_behaviors.append(shield_beh)
	coins = [coin]
	behavior.use(player, enemy, coins)
	assert_eq(player.get_stats().shield, 0)


func test_split_tails_do():
	behavior = SplitSkillBehavior.new()
	var damage_beh = DamageSkillBehavior.new()
	damage_beh.damage = 10
	var shield_beh = ShieldSkillBehavior.new()
	shield_beh.shield = 10
	var coin: Coin = DEFAULT_COIN.create_coin_instance()
	coin.heads = false
	behavior.heads_behaviors.append(damage_beh)
	behavior.tails_behaviors.append(shield_beh)
	coins = [coin]
	behavior.use(player, enemy, coins)
	assert_eq(player.get_stats().shield, 10)

func test_split_tails_dont():
	behavior = SplitSkillBehavior.new()
	var damage_beh = DamageSkillBehavior.new()
	damage_beh.damage = 10
	var shield_beh = ShieldSkillBehavior.new()
	shield_beh.shield = 10
	var coin: Coin = DEFAULT_COIN.create_coin_instance()
	coin.heads = false
	behavior.heads_behaviors.append(damage_beh)
	behavior.tails_behaviors.append(shield_beh)
	coins = [coin]
	behavior.use(player, enemy, coins)
	assert_eq(enemy.get_stats().health, 100)

func test_split_multiple_heads():
	behavior = SplitSkillBehavior.new()
	var damage_beh = DamageSkillBehavior.new()
	damage_beh.damage = 10
	var shield_beh = ShieldSkillBehavior.new()
	shield_beh.shield = 10
	var coin: Coin = DEFAULT_COIN.create_coin_instance()
	coin.heads = true
	behavior.heads_behaviors.append(damage_beh)
	behavior.heads_behaviors.append(damage_beh)
	behavior.tails_behaviors.append(shield_beh)
	coins = [coin]
	behavior.use(player, enemy, coins)
	assert_eq(enemy.get_stats().health, 80)

func test_split_multiple_tails():
	behavior = SplitSkillBehavior.new()
	var damage_beh = DamageSkillBehavior.new()
	damage_beh.damage = 10
	var shield_beh = ShieldSkillBehavior.new()
	shield_beh.shield = 10
	var coin: Coin = DEFAULT_COIN.create_coin_instance()
	coin.heads = false
	behavior.heads_behaviors.append(damage_beh)
	behavior.tails_behaviors.append(shield_beh)
	behavior.tails_behaviors.append(shield_beh)
	coins = [coin]
	behavior.use(player, enemy, coins)
	assert_eq(player.get_stats().shield, 20)


func test_split_finished_heads():
	behavior = SplitSkillBehavior.new()
	watch_signals(behavior)
	var coin: Coin = DEFAULT_COIN.create_coin_instance()
	coin.heads = true
	behavior.heads_behaviors.append(SkillBehavior.new())
	behavior.tails_behaviors.append(SkillBehavior.new())
	coins = [coin]
	behavior.use(player, enemy, coins)
	assert_signal_emitted(behavior, 'finished')
	
func test_split_finished_tails():
	behavior = SplitSkillBehavior.new()
	watch_signals(behavior)
	var coin: Coin = DEFAULT_COIN.create_coin_instance()
	coin.heads = false
	behavior.heads_behaviors.append(SkillBehavior.new())
	behavior.tails_behaviors.append(SkillBehavior.new())
	coins = [coin]
	behavior.use(player, enemy, coins)
	assert_signal_emitted(behavior, 'finished')

func test_split_finished_multiple_heads():
	behavior = SplitSkillBehavior.new()
	watch_signals(behavior)
	var coin: Coin = DEFAULT_COIN.create_coin_instance()
	coin.heads = true
	behavior.heads_behaviors.append(SkillBehavior.new())
	behavior.heads_behaviors.append(SkillBehavior.new())
	behavior.tails_behaviors.append(SkillBehavior.new())
	coins = [coin]
	behavior.use(player, enemy, coins)
	assert_signal_emitted(behavior, 'finished')

func test_split_finished_multiple_tails():
	behavior = SplitSkillBehavior.new()
	watch_signals(behavior)
	var coin: Coin = DEFAULT_COIN.create_coin_instance()
	coin.heads = true
	behavior.heads_behaviors.append(SkillBehavior.new())
	behavior.tails_behaviors.append(SkillBehavior.new())
	behavior.tails_behaviors.append(SkillBehavior.new())
	coins = [coin]
	behavior.use(player, enemy, coins)
	assert_signal_emitted(behavior, 'finished')
