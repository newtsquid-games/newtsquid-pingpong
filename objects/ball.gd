extends Node3D

enum DeflectionType {VERTICAL, HORIZONTAL, NONE}

@export var paddleRadius := 2.0
@export var leftPaddle : Node3D
@export var rightPaddle : Node3D
@export var margin := 0.1
@export var bounds = 5.0

@export var hitVelocityDamping = 0.5
@export var baseBallSpeed := 4.0
@export var resetBallInput := "ResetBall"

@export var difficultyInterval := 5
@export var ballSpeedIncrement := 1

@onready var collisionCount:int = 0
@onready var ballspeed:float = 0.0
@onready var horizontalDirection:int = -1
@onready var verticalDirection:int = -1

signal paddle_collision(collision_count)
signal paddle_miss

var verticalVelocity:float = 0.5
var pausedBallSpeed:float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
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
		verticalVelocity = area.getDeflectionVerticalVelocity(global_position)

	#if (area.is_in_group("Paddles")):
		#horizontalDirection *= -1
		#collisionCount += 1
		#paddle_collision.emit(collisionCount)
	#elif (area.is_in_group("Walls")):
		#verticalDirection *= -1
	#elif (area.is_in_group("Boundaries")):
		#collisionCount = 0
		#resetBall()
		#paddle_miss.emit()
	#else:
		#print("Unexpected collision with: " + area.name)
	
	if (collisionCount > 0 && collisionCount % difficultyInterval == 0):
		ballspeed += ballSpeedIncrement
	

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
