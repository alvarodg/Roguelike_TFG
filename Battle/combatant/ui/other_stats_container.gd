extends Control

@onready var strength_container = %StrengthContainer
@onready var strength_label = %StrengthLabel
@onready var armor_container = %ArmorContainer
@onready var armor_label = %ArmorLabel
@onready var dodges_container = %DodgesContainer
@onready var dodges_label = %DodgesLabel
@onready var info_container = %InfoContainer
@onready var info_label = %InfoLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func setup(player: Player):
	_update_armor(player.stats.armor)
	_update_dodges(player.stats.dodges)
	_update_strength(player.stats.strength)
	_hide_info()
	player.stats.armor_changed.connect(_on_Player_armor_changed)
	player.stats.dodges_changed.connect(_on_Player_dodges_changed)
	player.stats.strength_changed.connect(_on_Player_strength_changed)

func _on_Player_armor_changed(old, armor):
	var tween = create_tween()
	tween.tween_method(_update_armor, old, armor, 0.1)
	await tween.finished
	
func _on_Player_dodges_changed(old, dodges):
	var tween = create_tween()
	tween.tween_method(_update_dodges, old, dodges, 0.1)
	await tween.finished
	
func _on_Player_strength_changed(old, strength):
	var tween = create_tween()
	tween.tween_method(_update_strength, old, strength, 0.1)
	await tween.finished

func _update_armor(armor):
	if armor > 0:
		armor_container.show()
		armor_label.text = str(armor)# + " Armor"
	else:
		armor_container.hide()
	
func _update_dodges(dodges):
	if dodges > 0:
		dodges_container.show()
		dodges_label.text = str(dodges)
	else:
		dodges_container.hide()

func _update_strength(strength):
	if strength > 0:
		strength_container.show()
		strength_label.text = str(strength)
	else:
		strength_container.hide()

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
	HoverPanel.move_to_corner(info_container, HoverContainer.Corner.TOP_RIGHT, container.position, container.size)
	info_container.show()

func _hide_info():
	info_container.position = Vector2.ZERO
	info_container.hide()

