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
@onready var animation_player = $AnimationPlayer

const UPCOMING_AMOUNT: int = 4

# Usando enum para estrategias simples, cambiar por clase si se quisieran implementar más complejas.
enum Strategy {PURE_RANDOM, POP_RANDOM, SEQUENCE}

var ui_data: EnemyUIData
var stats: EnemyStats = EnemyStats.new()
var skills: Array[SkillData]
var available_skills: Array[SkillData]
#var equipment_list: Array[Equipment]
var strategy = Strategy.PURE_RANDOM

var target
var upcoming_skills: Array[SkillData]



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
	
func setup(data: EnemyData):
	ui_data = data.ui_data
	# Duplica stats para que se puedan reutilizar.
	stats = data.stats.duplicate()
	skills = data.skills
	strategy = data.strategy
	available_skills = skills.duplicate()
	equipment_list = data.equipment_list.duplicate()
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
	stats.start_battle()
	for i in range(UPCOMING_AMOUNT):
		add_upcoming_skill(pick_skill(strategy))
	started_battle.emit()

func start_turn():
	pre_started_turn.emit()
	target = combatants.player
	stats.start_turn()
	started_turn.emit()
	act()
#	turn_finished.emit()

func act():
	var action: Skill = upcoming_skills.front().create_skill(self, target)
	action.finished.connect(_on_action_finished)
	add_child(action)
	var used = upcoming_skills.front()
	remove_upcoming_skill(upcoming_skills.front())
	add_upcoming_skill(pick_skill(strategy))
	action.use()
	used_skill.emit(used)

func _on_action_finished():
	turn_finished.emit()

func _on_death():
	about_to_die.emit()
	await enemy_stats_ui.health_animation_finished
	animation_player.play("death")
	await animation_player.animation_finished
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

func take_damage(amount: int, ignore_shield = false, ignore_armor = false, ignore_dodges = false, shield_factor = 1.0):
	stats.take_damage(amount, ignore_shield, ignore_armor, ignore_dodges, shield_factor)

func _on_hit(damage):
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(%Sprite, "modulate", Color(Color.WHITE, 0.3), 0.15).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(%Sprite, "modulate", Color.WHITE, 0.15).set_trans(Tween.TRANS_BOUNCE)
	var number = DAMAGE_NUMBER.instantiate()
	add_child(number)
	number.setup(damage, battle_position, sprite.size.x, stats.max_health)
	number.display_and_free()


func _on_Stats_changed(_old = null, _value = null, _other = null):
	stats_changed.emit(stats)


