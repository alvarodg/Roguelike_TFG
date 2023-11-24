extends Resource
class_name EnemyData

var enemy_scene = preload("res://Battle/enemy/enemy.tscn")
@export var enemy_ui_data: EnemyUIData
@export var enemy_stats: EnemyStats

func create_enemy_instance():
	var enemy = enemy_scene.instantiate()
	enemy.setup(enemy_ui_data, enemy_stats)
	return enemy
