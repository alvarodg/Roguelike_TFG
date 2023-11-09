extends Resource
class_name TurnManager

# Adaptación a Godot 4 del sistema del vídeo "My Turn Manager Code in Godot" de Heartbeast.
# https://www.youtube.com/watch?v=umC2i8jwUKM

signal environment_turn_started
signal player_turn_started
signal enemy_turn_started

enum Turn {ENVIRONMENT_TURN, PLAYER_TURN, ENEMY_TURN}
var turn :Turn : set = set_turn

func set_turn(value: Turn):
	turn = value
	match turn:
		Turn.ENVIRONMENT_TURN: environment_turn_started.emit()
		Turn.PLAYER_TURN: player_turn_started.emit()
		Turn.ENEMY_TURN: enemy_turn_started.emit()
	
