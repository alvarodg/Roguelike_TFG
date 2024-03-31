extends VBoxContainer

signal health_animation_finished

@onready var health_bar = %HealthBar
@onready var strength_label = %StrengthLabel
@onready var shield_label = %ShieldLabel
@onready var armor_label = %ArmorLabel
@onready var dodges_label = %DodgesLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setup(enemy: EnemyStats):
	health_bar.setup(enemy)
	_update_shield(enemy.shield)
	_update_strength(enemy.strength)
	_update_armor(enemy.armor)
	_update_dodges(enemy.dodges)
	health_bar.health_animation_finished.connect(_on_health_animation_finished)
	enemy.shield_changed.connect(_on_Enemy_shield_changed)
	enemy.strength_changed.connect(_on_Enemy_strength_changed)
	enemy.armor_changed.connect(_on_Enemy_armor_changed)
	enemy.dodges_changed.connect(_on_Enemy_dodges_changed)

func _on_Enemy_shield_changed(shield):
	_update_shield(shield)
	
func _on_Enemy_strength_changed(strength):
	_update_strength(strength)
	
func _on_Enemy_armor_changed(armor):
	_update_armor(armor)
	
func _on_Enemy_dodges_changed(dodges):
	_update_dodges(dodges)
	
func _update_shield(shield):
	if shield > 0:
		shield_label.show()
		shield_label.text = str(shield) + " Shield"
	else:
		shield_label.hide()

func _update_strength(strength):
	if strength > 0:
		strength_label.show()
		strength_label.text = str(strength) + " Strength"
	else:
		strength_label.hide()

func _update_armor(armor):
	if armor > 0:
		armor_label.show()
		armor_label.text = str(armor) + " Armor"
	else:
		armor_label.hide()
	
func _update_dodges(dodges):
	if dodges > 0:
		dodges_label.show()
		dodges_label.text = str(dodges) + " Dodges"
	else:
		dodges_label.hide()

func _on_health_animation_finished():
	health_animation_finished.emit()
