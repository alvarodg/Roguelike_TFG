extends Control
class_name EquipmentIcon

var equipment: Equipment
@onready var sprite = %Sprite
@onready var info_panel = %InfoPanel
@onready var info_label = %InfoLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.texture = equipment.ui_data.icon
	info_label.text = equipment.ui_data.ui_name + ":\n" +equipment.get_description()
	info_label.hide()

func setup(p_equipment: Equipment):
	equipment = p_equipment

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Versión básica de mostrar la información cuando se pase el ratón
func _on_mouse_entered():
	info_label.show()

func _on_mouse_exited():
	info_label.hide()
