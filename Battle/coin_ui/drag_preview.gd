extends Sprite2D

## Implementación de preview de objetos arrastrados usando el método mostrado por
## Artindi en su vídeo "How To Drag And Drop In Godot - Basic Level Explanation" 
## https://www.youtube.com/watch?v=IaAqhIC5DaI

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	global_position = get_global_mouse_position()
	
	if Input.is_action_just_released("click"):
		queue_free()
