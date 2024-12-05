extends Node3D

@onready var cinematicMode:bool = true
@onready var currentGameCollisionCount: int = 0

signal out_of_bounds
signal reset_game_state

func _on_left_boundary_barrier_crossed() -> void:
	out_of_bounds.emit()
	reset_game_state.emit()

func _on_right_boundary_barrier_crossed() -> void:
	out_of_bounds.emit()
	reset_game_state.emit()


func _on_paddle_right_paddle_collision() -> void:
	currentGameCollisionCount += 1
