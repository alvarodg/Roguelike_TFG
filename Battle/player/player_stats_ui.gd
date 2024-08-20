extends Control

var DAMAGE_NUMBER = load("res://Battle/animations/damage_number.tscn")

@onready var player_icon = %PlayerIcon
@onready var name_label = %NameLabel
@onready var equipment_ui = %EquipmentUI
@onready var health_bar = %HealthBar
@onready var armor_label = %ArmorLabel
@onready var dodges_label = %DodgesLabel
@onready var strength_label = %StrengthLabel
#@onready var coin_count_label = %CoinCountLabel
#@onready var coin_container = %CoinContainer
@onready var strength_container = %StrengthContainer
#@onready var shield_container = %ShieldContainer
@onready var armor_container = %ArmorContainer
@onready var dodges_container = %DodgesContainer
@onready var info_label = %InfoLabel
@onready var info_container = %InfoContainer


@onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	player_icon.pivot_offset = player_icon.texture.get_size() * player_icon.scale/2
	
func setup(player: Player):
	player_icon.texture = player.ui_data.sprite
	name_label.text = " " + player.ui_data.ui_name + " "
	player.battle_position = player_icon.global_position + Vector2(player_icon.size.x/2,0)
	equipment_ui.setup(player)
	health_bar.setup(player.stats)
	#_update_shield(player.stats.shield)
	_update_armor(player.stats.armor)
	_update_dodges(player.stats.dodges)
	_update_strength(player.stats.strength)
	_hide_info()
	#coin_count_label.text = str(player.stats.coin_count) + "x"
 	#player.stats.shield_changed.connect(_on_Player_shield_changed)
	player.stats.armor_changed.connect(_on_Player_armor_changed)
	player.stats.dodges_changed.connect(_on_Player_dodges_changed)
	player.stats.strength_changed.connect(_on_Player_strength_changed)
	#player.stats.coin_count_changed.connect(_on_Player_coin_count_changed)
	player.stats.hit.connect(_on_Player_hit)
	player.stats.died.connect(_on_Player_died)

#func _on_Player_coin_count_changed(_old, new):
	#coin_count_label.text = str(new) + "x"

#func _on_Player_shield_changed(old, shield):
	#var tween = create_tween()
	#tween.tween_method(_update_shield, old, shield, 0.1)
	#await tween.finished
##	_update_shield(shield)
	
func _on_Player_armor_changed(old, armor):
	var tween = create_tween()
	tween.tween_method(_update_armor, old, armor, 0.1)
	await tween.finished
#	_update_armor(armor)
	
func _on_Player_dodges_changed(old, dodges):
	var tween = create_tween()
	tween.tween_method(_update_dodges, old, dodges, 0.1)
	await tween.finished
#	_update_dodges(dodges)
	
func _on_Player_strength_changed(old, strength):
	var tween = create_tween()
	tween.tween_method(_update_strength, old, strength, 0.1)
	await tween.finished

#func _update_shield(shield):
	#if shield > 0:
		#shield_container.show()
		#shield_label.show()
		#shield_label.text = str(shield)# + " Shield"
	#else:
		#shield_label.hide()
		#shield_container.hide()

func _update_armor(armor):
	if armor > 0:
		armor_container.show()
		armor_label.text = str(armor)# + " Armor"
	else:
		armor_container.hide()
	
func _update_dodges(dodges):
	if dodges > 0:
		dodges_container.show()
		dodges_label.text = str(dodges)# + " Dodge"
		#if dodges > 1:
			#dodges_label.text += "s"
	else:
		dodges_container.hide()

func _update_strength(strength):
	if strength > 0:
		strength_container.show()
		strength_label.text = str(strength)
	else:
		strength_container.hide()

func _on_Player_hit(damage, health, max_health):
	print("hit")
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(%PlayerIcon, "modulate", Color(Color.WHITE, 0.3), 0.15).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(%PlayerIcon, "modulate", Color.WHITE, 0.15).set_trans(Tween.TRANS_BOUNCE)
	var number = DAMAGE_NUMBER.instantiate()
	add_child(number)
	number.setup(damage, player_icon.global_position + player_icon.size/2, -player_icon.size.x, max_health)
	number.display_and_free()
#	animation_player.play("player_hit")
#	await animation_player.animation_finished

func _on_Player_died():
	animation_player.play("die")
	await animation_player.animation_finished


func _on_StrengthContainer_mouse_entered():
	var strength_description = "Strength: Increases damage dealt"
	_update_info(strength_container, strength_description)
	#info_label.text = strength_description
	#info_panel.size = info_label.size
	#info_label.global_position = strength_container.global_position - Vector2(0,strength_container.size.y/2)
	#info_label.show()

func _on_StrengthContainer_mouse_exited():
	_hide_info()

func _on_ArmorContainer_mouse_entered():
	var armor_description = "Armor: Decreases damage received"
	_update_info(armor_container, armor_description)
	#info_label.text = armor_description
	#info_panel.size = info_label.size
	#info_label.global_position = armor_container.global_position - Vector2(0,armor_container.size.y/2)
	#info_label.show()

func _on_ArmorContainer_mouse_exited():
	_hide_info()

func _on_DodgesContainer_mouse_entered():
	var dodges_description = "Dodges: Avoids next damage instance taken"
	_update_info(dodges_container, dodges_description)
	#info_label.text = dodges_description
	#info_container.global_position = dodges_container.global_position - Vector2(0,dodges_container.size.y/2)
	#info_container.show()
	#info_label.global_position = dodges_container.global_position - Vector2(0,dodges_container.size.y/2)
	#info_label.show()


func _on_DodgesContainer_mouse_exited():
	_hide_info()

func _update_info(container: Container, description: String):
	info_label.text = description
	info_container.global_position = container.global_position - Vector2(0,container.size.y/2)
	info_container.show()

func _hide_info():
	info_container.hide()
