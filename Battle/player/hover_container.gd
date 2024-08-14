extends PanelContainer
## Contenedor de panel de texto que puede aparecer a cualquier esquina de un 
## objeto, indicado para cuando se pase el ratón por encima de este.
## No se usa debido al funcionamiento extraño (posible bug) de 
## set_anchors_preset en escenas instanciadas, no cambia haga lo que haga.
class_name HoverContainer

enum Corner {TOP_LEFT, TOP_RIGHT, BOTTOM_LEFT, BOTTOM_RIGHT}

@onready var info_label = %InfoLabel

var description: String
var corner: HoverContainer.Corner
var hoverable_position: Vector2
var hoverable_size: Vector2
var is_set: bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	info_label.text = description
	#move_to_corner(corner)

func _process(delta):
	if !is_set:
		#move_to_corner(corner)
		is_set = true

func setup(p_description: String, p_position: Vector2, p_size: Vector2):
	description = p_description
	hoverable_position = p_position
	hoverable_size = p_size

func move_to_corner(to_corner: HoverContainer.Corner):
	info_label.text = description
	print("Pre_ mod" + str(anchors_preset))
	print("To corner:" + str(to_corner))
	match to_corner:
		Corner.TOP_LEFT:
			print("in top left")
			#anchors_preset = PRESET_BOTTOM_RIGHT
			position = get_global_mouse_position()
			set_anchors_preset(Control.PRESET_BOTTOM_RIGHT, false)
			#var target_point = - hoverable_size
			#global_position += hoverable_position + target_point
		Corner.TOP_RIGHT:
			print("in top right")
			#anchors_preset = PRESET_BOTTOM_LEFT
			position = get_global_mouse_position()
			set_anchors_preset(Control.PRESET_BOTTOM_LEFT, false)
			#var target_point = Vector2(hoverable_size.x, -hoverable_size.y)
			#global_position += hoverable_position + target_point
		Corner.BOTTOM_LEFT:
			print("in bot left")
			#anchors_preset = PRESET_TOP_RIGHT
			position = get_global_mouse_position()
			set_anchors_preset(Control.PRESET_TOP_RIGHT, false)
			#var target_point = Vector2(-hoverable_size.x, hoverable_size.y)
			#global_position += hoverable_position + target_point
		Corner.BOTTOM_RIGHT:
			print("in bot right")
			set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
			#anchors_preset = PRESET_TOP_LEFT
			position = get_global_mouse_position()
			#var target_point = hoverable_size
			#global_position += hoverable_position + target_point
	print("Post_mod:" + str(anchors_preset))
