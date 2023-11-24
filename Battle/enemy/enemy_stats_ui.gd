extends VBoxContainer

@onready var health_bar = %HealthBar
@onready var shield_label = %ShieldLabel
@onready var damage_label = %DamageLabel
@onready var armor_label = %ArmorLabel
@onready var dodges_label = %DodgesLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setup(enemy: EnemyStats):
	health_bar.setup(enemy)
	_update_shield(enemy.shield)
	_update_damage(enemy.damage)
	_update_armor(enemy.armor)
	_update_dodges(enemy.dodges)
	enemy.shield_changed.connect(_on_Enemy_shield_changed)
	enemy.damage_changed.connect(_on_Enemy_damage_changed)
	enemy.armor_changed.connect(_on_Enemy_armor_changed)
	enemy.dodges_changed.connect(_on_Enemy_dodges_changed)

func _on_Enemy_shield_changed(shield):
	_update_shield(shield)
	
func _on_Enemy_damage_changed(damage):
	_update_damage(damage)
	
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

func _update_damage(damage):
	damage_label.text = str(damage) + " Damage"

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
