extends Node3D

enum DeflectionType {VERTICAL, HORIZONTAL, NONE}

@export var hitVelocityDamping:float = 0.5
@export var baseBallSpeed:float = 4.0
@export var resetBallInput:String = "ResetBall"

@export var difficultyIncrementBallSpeed:float = 1

@onready var collisionCount:int = 0
@onready var ballspeed:float = 0.0
@onready var horizontalDirection:int = -1
@onready var verticalDirection:int = -1

var verticalVelocity:float = 0
	
func _input(event):
	if event.is_action(resetBallInput)  && event.is_pressed():
		position = Vector3.ZERO
		

func _physics_process(delta: float) -> void:
	position.x += delta * ballspeed * horizontalDirection
	position.z += verticalVelocity * delta * ballspeed * verticalDirection

func _on_ball_area_area_entered(area: Area3D) -> void:
	print(area.name)
	if (area.has_method("getDeflectionType")):
		var deflectionType:int = area.getDeflectionType()
		if (deflectionType == DeflectionType.VERTICAL):
			verticalDirection *= -1
		if (deflectionType == DeflectionType.HORIZONTAL):
			horizontalDirection *= -1
	
	if (area.has_method("getDeflectionVerticalVelocity")):
		verticalVelocity = lerp(area.getDeflectionVerticalVelocity(global_position), verticalVelocity, hitVelocityDamping)
	

func increaseBallSpeed(amount: float):
	ballspeed += amount

func resetBall():
	ballspeed = baseBallSpeed
	position = Vector3.ZERO

func _on_main_menu_game_reset() -> void:
	resetBall()

func _on_main_menu_game_started() -> void:
	ballspeed = baseBallSpeed

func _on_play_space_reset_game_state() -> void:
	resetBall()

func _on_play_space_increase_difficulty() -> void:
	increaseBallSpeed(difficultyIncrementBallSpeed)
