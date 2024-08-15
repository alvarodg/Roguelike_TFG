extends Control

@onready var health_bar = %HealthBar
@onready var equipment_ui = %EquipmentUI
@onready var coin_count_label = %CoinCountLabel
@onready var player_equipment_panel = %PlayerEquipmentPanel
@onready var coin_icon_container = %CoinIconContainer

@export var corner: HoverContainer.Corner
@export var show_coins: bool = true
@export var show_equipment: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	if not show_coins:
		coin_icon_container.hide()
	if not show_equipment:
		player_equipment_panel.hide()
	equipment_ui.corner = corner


func setup(player: Player):
	equipment_ui.setup(player)
	health_bar.setup(player.stats)
	_update_coin_count(player.get_coin_count())
	player.coin_count_changed.connect(_on_Player_coin_count_changed)
	
func _update_coin_count(count: int):
	coin_count_label.text = "x"+ str(count)

func _on_Player_coin_count_changed(_old, count):
	_update_coin_count(count)
