extends Node3D

@export var difficultyInterval:int = 5

@onready var currentCollisionCount: int = 0

signal out_of_bounds
signal reset_game_state
signal increase_difficulty

# HUD SIGNALS
signal player_one_scored
signal player_two_scored

func _on_left_boundary_barrier_crossed() -> void:
	player_two_scored.emit()
	out_of_bounds.emit()
	reset_game_state.emit()

func _on_right_boundary_barrier_crossed() -> void:
	player_one_scored.emit()
	out_of_bounds.emit()
	reset_game_state.emit()

# PADDLE FUNCs
func _on_paddle_right_paddle_collision() -> void:
	handlePaddleCollision()

func _on_paddle_left_paddle_collision() -> void:
	handlePaddleCollision()

func handlePaddleCollision() -> void:
	currentCollisionCount += 1
	
	if (currentCollisionCount % difficultyInterval == 0):
		increase_difficulty.emit()
		
	
