extends RefCounted
class_name HoverPanel

static func move_to_corner(p_hover_panel, to_corner: HoverContainer.Corner, target_pos: Vector2, target_size: Vector2):
	if p_hover_panel != null:
		match to_corner:
			HoverContainer.Corner.TOP_LEFT:
				p_hover_panel.anchors_preset = Control.PRESET_BOTTOM_RIGHT
				#hover_panel.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
				var sprite_point = - target_size
				p_hover_panel.position += target_pos + sprite_point
			HoverContainer.Corner.TOP_RIGHT:
				p_hover_panel.anchors_preset = Control.PRESET_BOTTOM_LEFT
				#hover_panel.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
				#var sprite_point = - sprite.texture.get_size() * sprite.scale
				var sprite_point = Vector2(target_size.x, -target_size.y) 
				p_hover_panel.position += target_pos + sprite_point
			HoverContainer.Corner.BOTTOM_LEFT:
				p_hover_panel.anchors_preset = Control.PRESET_TOP_RIGHT
				#var sprite_point = - sprite.texture.get_size() * sprite.scale
				var sprite_point = Vector2(-target_size.x, target_size.y)
				p_hover_panel.position += target_pos + sprite_point
			HoverContainer.Corner.BOTTOM_RIGHT:
				p_hover_panel.anchors_preset = Control.PRESET_TOP_LEFT
				var sprite_point = target_size
				p_hover_panel.position += target_pos + sprite_point
