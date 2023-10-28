extends Control
class_name EventNode

@onready var button: Button = %Button
var index: int = 0
var descendants: Array[EventNode] = []
var lines: Array[Line2D] = []
@onready var center_container = $CenterContainer

func _draw():
	var from = global_position - position
	for d in descendants:
		var to = d.global_position - position
		draw_line(from, to, Color.WHITE, 2.0)
#		var line = Line2D.new()
#		line.add_point(from)
#		line.add_point(to)
#		line.width = 2.0
#		add_child(line)
#		lines.append(line)

func add_descendant(descendant: EventNode):
	if descendant not in descendants:
		descendants.append(descendant)

func remove_descendant(descendant: EventNode):
	var descendant_index = descendants.find(descendant)
	if descendant_index >= 0:
		descendants.pop_at(descendant_index)
		
func set_text(text):
	button.text = text

func _on_Button_pressed():
	pass
