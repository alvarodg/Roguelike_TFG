extends Resource
class_name EnemyData

var enemy_scene = preload("res://Battle/enemy/enemy.tscn")
@export var ui_data: EnemyUIData
@export var stats: EnemyStats
@export var skills: Array[SkillData]
@export var equipment_list: Array[Equipment]
@export var strategy: Enemy.Strategy

func create_enemy_instance():
	var enemy = enemy_scene.instantiate()
	enemy.setup(ui_data, stats, skills, equipment_list, strategy)
	return enemy
