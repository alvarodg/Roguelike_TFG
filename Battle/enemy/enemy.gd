extends Combatant
class_name Enemy

#signal started_battle
#signal started_turn
#signal turn_finished
#signal died
signal upcoming_skills_changed(value)
#signal equipment_changed(value)

@onready var combatants = load("res://Battle/resources/Combatants.tres")

@onready var sprite = %Sprite
@onready var enemy_stats_ui = %EnemyStatsUI
@onready var enemy_skill_ui = %EnemySkillUI
@onready var equipment_ui = %EquipmentUI

const UPCOMING_AMOUNT: int = 4

var ui_data: EnemyUIData
var stats: EnemyStats
var skills: Array[SkillData]
var available_skills: Array[SkillData]
var equipment_list: Array[Equipment]
var strategy

var target
var upcoming_skills: Array[SkillData]

# Usando enum para estrategias simples, cambiar por clase si se quisieran implementar más complejas.
enum Strategy {PURE_RANDOM, POP_RANDOM, SEQUENCE}

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(stats is EnemyStats)
	target = combatants.player
	sprite.texture = ui_data.sprite
	battle_position = sprite.global_position + sprite.size/2
	stats.setup()
	for equipment in equipment_list:
		equip(equipment)
	equipment_ui.setup(self)
	stats.start_battle()
	enemy_stats_ui.setup(stats)
	enemy_skill_ui.setup(self)
	
func setup(p_ui_data: EnemyUIData, p_stats: EnemyStats, p_skills: Array[SkillData], p_equipment_list: Array[Equipment], p_strategy: Strategy):
	ui_data = p_ui_data
	# Duplica stats para que se puedan reutilizar.
	stats = p_stats.duplicate()
	skills = p_skills
	strategy = p_strategy
	available_skills = skills.duplicate()
	equipment_list = p_equipment_list.duplicate()
	connect_to_stat_signals(stats)
	
func set_new_stats(new_stats: EnemyStats):
	stats = new_stats.duplicate()
	enemy_stats_ui.setup(stats)
	connect_to_stat_signals(stats)
	
func get_stats() -> EnemyStats:
	return stats
	
func get_ui_data() -> EnemyUIData:
	return ui_data
	
func add_upcoming_skill(skill: SkillData, back: bool = true):
	if back:
		upcoming_skills.append(skill)
	else:
		upcoming_skills.push_front(skill)
	upcoming_skills_changed.emit(upcoming_skills)
	
func remove_upcoming_skill(skill: SkillData):
	upcoming_skills.erase(skill)
	upcoming_skills_changed.emit(upcoming_skills)
	
func connect_to_stat_signals(p_stats):
	p_stats.died.connect(_on_death)
	p_stats.hit.connect(_on_hit)
	p_stats.armor_changed.connect(_on_Stats_changed)
	p_stats.dodges_changed.connect(_on_Stats_changed)
	p_stats.health_changed.connect(_on_Stats_changed)
	p_stats.shield_changed.connect(_on_Stats_changed)
	p_stats.strength_changed.connect(_on_Stats_changed)
	p_stats.max_health_changed.connect(_on_Stats_changed)


func remove_available_skill(skill: SkillData):
	if not skill is SkillData: return
	available_skills.erase(skill)
	if available_skills == []:
		available_skills = skills.duplicate()

func replace_available_skills(skill_list: Array[SkillData]):
	available_skills = skill_list
	upcoming_skills = []
	for i in range(UPCOMING_AMOUNT):
		add_upcoming_skill(pick_skill(strategy))

func start_battle():
	print("Battle started")
	stats.start_battle()
	for i in range(UPCOMING_AMOUNT):
		add_upcoming_skill(pick_skill(strategy))
	started_battle.emit()

func start_turn():
	pre_started_turn.emit()
	print("Turn started")
	target = combatants.player
	stats.start_turn()
	started_turn.emit()
	act()
	turn_finished.emit()

func act():
	var action = upcoming_skills.front().create_skill(self, target)
	action.use()
	remove_upcoming_skill(upcoming_skills.front())
	add_upcoming_skill(pick_skill(strategy))

func _on_death():
	print("Died")
	died.emit()

func pick_skill(strat: Strategy) -> SkillData:
	var pick: SkillData
	match strat:
		Strategy.PURE_RANDOM:
			pick = available_skills.pick_random()
		Strategy.POP_RANDOM:
			pick = available_skills.pick_random()
			remove_available_skill(pick)
		Strategy.SEQUENCE:
			pick = available_skills.front()
			remove_available_skill(pick)
	return pick

func equip(equipment: Equipment):
	equipment.attach_to(self)
	equipment.setup()
	equipment_changed.emit(equipment_list)

func take_damage(amount: int):
	stats.take_damage(amount)

func _on_hit():
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(%Sprite, "modulate", Color(Color.WHITE, 0.3), 0.15).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(%Sprite, "modulate", Color.WHITE, 0.15).set_trans(Tween.TRANS_BOUNCE)

func _on_Stats_changed(_value):
	stats_changed.emit(stats)
