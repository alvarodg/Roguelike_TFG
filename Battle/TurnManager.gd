extends Resource
class_name TurnManager

# Adaptación a Godot 4 del sistema del vídeo "My Turn Manager Code in Godot" de Heartbeast.
# https://www.youtube.com/watch?v=umC2i8jwUKM

signal player_turn_started
signal enemy_turn_started

enum Turn {PLAYER_TURN, ENEMY_TURN}
var turn :Turn : set = set_turn

func set_turn(value: Turn):
	turn = value
	match turn:
		Turn.PLAYER_TURN: emit_signal("player_turn_started")
		Turn.ENEMY_TURN: emit_signal("enemy_turn_started")
	
