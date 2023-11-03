extends Resource
class_name Event

signal finished

@export var icon_normal: Texture2D
@export var icon_hover: Texture2D
@export var icon_traveled: Texture2D
@export var text: String = ""
@export var scene: PackedScene = load("res://Battle/Battle.tscn")
