extends Sprite2D
class_name DroppedItem

var angle: Vector2
var distance: float
var duration: float
var fade: bool = true
var shrink: bool = true

func setup(p_texture: Texture2D, p_global_pos: Vector2, p_angle: Vector2 = Vector2.DOWN, 
		p_distance: float = 0, p_duration: float = 1.0, p_fade: bool = true,
		p_shrink: bool = true):
	texture = p_texture
	global_position = p_global_pos
	angle = p_angle
	if distance == 0:
		distance = texture.get_size().y * 4
	else:
		distance = p_distance
	duration = p_duration
	fade = p_fade
	shrink = p_shrink
	

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Working")
	var tween: Tween = get_tree().create_tween()
	var target_pos: Vector2 = angle.normalized() * distance
	tween.set_parallel(true)
	tween.tween_property(self, 'position', position + target_pos, duration)
	if fade:
		tween.tween_property(self, 'modulate', Color.TRANSPARENT, duration)
	if shrink:
		tween.tween_property(self, 'scale', Vector2.ZERO, duration)
	await tween.finished
	print("Finished")
	queue_free()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
