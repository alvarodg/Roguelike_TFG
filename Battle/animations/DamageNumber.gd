extends Node2D
class_name DamageNumber

@onready var label = $Label
var mov_range
var number

func setup(amount, base_position: Vector2 = Vector2.ZERO, movement_range: float = 0, out_of: int = 0):
	global_position = base_position
	mov_range = movement_range
	number = amount
	# A diseñar
	if out_of > 0:
		var percent = amount/float(out_of)
		if percent < 0.1:
			pass
		elif percent < 0.4:
			pass
		else:
			pass
	
func display_and_free():
	label.text = str(number)
	var final_pos: Vector2 = Vector2(randf_range(-mov_range,mov_range), randf_range(0,mov_range))
	var tween = get_tree().create_tween()
	tween.tween_property(label, "self_modulate", Color.TRANSPARENT, 1)
	tween.parallel().tween_property(label, "position", final_pos, 1)
	await tween.finished
	queue_free()
#
#
#func _ready():
#	label.text = str(number)
#	var final_pos: Vector2 = Vector2(randf_range(0,mov_range), randf_range(0,mov_range))
#	var tween = get_tree().create_tween()
#	tween.tween_property(label, "self_modulate", Color.TRANSPARENT, 1)
#	tween.parallel().tween_property(label, "position", final_pos, 1)
#	await tween.finished
#	queue_free()
#
