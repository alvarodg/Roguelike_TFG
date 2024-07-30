extends GutTest

var modifier: Modifier
var player: Player
var enemy: Enemy
const DEFAULT_COIN = preload("res://Battle/coin_ui/resources/default_coin.tres")


func before_each():
	player = Player.new()
	enemy = Enemy.new()
	player.stats = PlayerStats.new(100)
	enemy.stats = EnemyStats.new(100)
