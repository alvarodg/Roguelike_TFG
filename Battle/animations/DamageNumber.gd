extends Node2D
class_name DamageNumber

@onready var label = $Label
var mov_range
var number

func setup(base_position: Vector2 = Vector2.ZERO, movement_range: float = 0, amount: int = 100):
	global_position = base_position
	mov_range = movement_range
	number = amount
	
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
