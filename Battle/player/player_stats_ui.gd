extends Control

@onready var player_icon = %PlayerIcon
@onready var equipment_ui = %EquipmentUI
@onready var health_bar = %HealthBar
@onready var shield_label = %ShieldLabel
@onready var armor_label = %ArmorLabel
@onready var dodges_label = %DodgesLabel

@onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func setup(player: Player):
	player.battle_position = player_icon.global_position + player_icon.size/2
	player_icon = player.ui_data.sprite
	equipment_ui.setup(player)
	health_bar.setup(player.stats)
	_update_shield(player.stats.shield)
	_update_armor(player.stats.armor)
	_update_dodges(player.stats.dodges)
	player.stats.shield_changed.connect(_on_Player_shield_changed)
	player.stats.armor_changed.connect(_on_Player_armor_changed)
	player.stats.dodges_changed.connect(_on_Player_dodges_changed)
	player.stats.hit.connect(_on_Player_hit)
	
func _on_Player_shield_changed(shield):
	_update_shield(shield)
	
func _on_Player_armor_changed(armor):
	_update_armor(armor)
	
func _on_Player_dodges_changed(dodges):
	_update_dodges(dodges)
	
func _update_shield(shield):
	if shield > 0:
		shield_label.show()
		shield_label.text = str(shield) + " Shield"
	else:
		shield_label.hide()

func _update_armor(armor):
	if armor > 0:
		armor_label.show()
		armor_label.text = str(armor) + " Armor"
	else:
		armor_label.hide()
	
func _update_dodges(dodges):
	if dodges > 0:
		dodges_label.show()
		dodges_label.text = str(dodges) + " Dodge"
		if dodges > 1:
			dodges_label.text += "s"
	else:
		dodges_label.hide()

func _on_Player_hit():
	print("hit")
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(%PlayerIcon, "modulate", Color(Color.WHITE, 0.3), 0.15).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(%PlayerIcon, "modulate", Color.WHITE, 0.15).set_trans(Tween.TRANS_BOUNCE)
#	animation_player.play("player_hit")
#	await animation_player.animation_finished
