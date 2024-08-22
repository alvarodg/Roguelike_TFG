extends Control

signal health_animation_finished

@onready var health_bar = %HealthBar
@onready var strength_label = %StrengthLabel
@onready var armor_label = %ArmorLabel
@onready var dodges_label = %DodgesLabel
@onready var strength_container = %StrengthContainer
@onready var armor_container = %ArmorContainer
@onready var dodges_container = %DodgesContainer
@onready var other_stats_container = %OtherStatsContainer
@onready var v_box_container = %VBoxContainer
@onready var info_container = %InfoContainer
@onready var info_label = %InfoLabel

@export var health_above: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if health_above:
		v_box_container.move_child(health_bar, 0)
		v_box_container.alignment = BoxContainer.ALIGNMENT_BEGIN
	else:
		v_box_container.alignment = BoxContainer.ALIGNMENT_END
	_hide_info()

func setup(enemy: EnemyStats):
	health_bar.setup(enemy)
	#_update_shield(enemy.shield)
	_update_strength(enemy.strength)
	_update_armor(enemy.armor)
	_update_dodges(enemy.dodges)
	health_bar.health_animation_finished.connect(_on_health_animation_finished)
	#enemy.shield_changed.connect(_on_Enemy_shield_changed)
	enemy.strength_changed.connect(_on_Enemy_strength_changed)
	enemy.armor_changed.connect(_on_Enemy_armor_changed)
	enemy.dodges_changed.connect(_on_Enemy_dodges_changed)

#func _on_Enemy_shield_changed(old, shield):
	#var tween = create_tween()
	#tween.tween_method(_update_shield, old, shield, 0.5)
	#_update_shield(shield)
	
func _on_Enemy_strength_changed(old, strength):
	var tween = create_tween()
	tween.tween_method(_update_strength, old, strength, 0.5)
	_update_strength(strength)
	
func _on_Enemy_armor_changed(old, armor):
	var tween = create_tween()
	tween.tween_method(_update_armor, old, armor, 0.5)
	_update_armor(armor)
	
func _on_Enemy_dodges_changed(old, dodges):
	var tween = create_tween()
	tween.tween_method(_update_dodges, old, dodges, 0.5)
	_update_dodges(dodges)
	
#func _update_shield(shield):
	#if shield > 0:
		#shield_label.show()
		#shield_label.text = str(shield) + " Shield"
	#else:
		#shield_label.hide()

func _update_strength(strength):
	if strength > 0:
		strength_container.show()
		strength_label.text = str(strength)
	else:
		strength_container.hide()

func _update_armor(armor):
	if armor > 0:
		armor_container.show()
		armor_label.text = str(armor)
	else:
		armor_container.hide()
	
func _update_dodges(dodges):
	if dodges > 0:
		dodges_container.show()
		dodges_label.text = str(dodges)
	else:
		dodges_container.hide()

func _on_health_animation_finished():
	health_animation_finished.emit()

func _on_StrengthContainer_mouse_entered():
	var strength_description = "Strength: Increases damage dealt"
	_update_info(strength_container, strength_description)

func _on_StrengthContainer_mouse_exited():
	_hide_info()

func _on_ArmorContainer_mouse_entered():
	var armor_description = "Armor: Decreases damage received"
	_update_info(armor_container, armor_description)

func _on_ArmorContainer_mouse_exited():
	_hide_info()

func _on_DodgesContainer_mouse_entered():
	var dodges_description = "Dodges: Avoids next damage instance taken"
	_update_info(dodges_container, dodges_description)

func _on_DodgesContainer_mouse_exited():
	_hide_info()

func _update_info(container: Container, description: String):
	info_label.text = description
	HoverPanel.move_to_corner(info_container, HoverContainer.Corner.TOP_LEFT, container.position, container.size)
	info_container.show()

func _hide_info():
	info_container.position = Vector2.ZERO
	info_container.hide()
