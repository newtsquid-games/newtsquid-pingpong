extends Node3D
@export var paddleRadius := 2.0
@export var leftPaddle : Node3D
@export var rightPaddle : Node3D
@export var margin := 0.1
@export var bounds = 5.0

@export var hitVelocityDamping = 0.5

@export var baseBallSpeed := 4.0

@export var upInput := "MoveUp1"
@export var downInput := "MoveDown1"
@export var resetBallInput := "ResetBall"

@export var difficultyInterval := 5
@export var ballSpeedIncrement := 1

@onready var me := $"."
@onready var collisionCount := 0
@onready var ballspeed := 0.0

signal paddle_collision(collision_count)
signal paddle_miss

var rightBound := true
var verticalVelocity := 0.5
var pausedBallSpeed = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _input(event):
	if event.is_action(resetBallInput)  && event.is_pressed():
		me.position = Vector3.ZERO
		

func collisionCheck():	
	var atLimit = false
	
	if me.position.z > bounds && verticalVelocity > 0:
		verticalVelocity *= -1	
	elif me.position.z < -bounds && verticalVelocity < 0:
		verticalVelocity *= -1
	
	if(me.position.x > bounds && me.position.x < bounds + margin):
		atLimit = true	
	elif(me.position.x < -bounds && me.position.x > -bounds - margin):
		atLimit = true
			
	if(atLimit):
		var left = leftPaddle.getPaddlePos()
		var right = rightPaddle.getPaddlePos()
		#run if collide
		if !rightBound && absf(left.z - me.position.z) < paddleRadius:
			collisionCount += 1
			verticalVelocity = lerp(-(left.z - me.position.z), verticalVelocity, hitVelocityDamping)
			rightBound = !rightBound
			paddle_collision.emit(collisionCount)	
		elif rightBound && absf(right.z - me.position.z) < paddleRadius:
			collisionCount += 1
			verticalVelocity = lerp(-(right.z - me.position.z), verticalVelocity, hitVelocityDamping)
			rightBound = !rightBound
			paddle_collision.emit(collisionCount)
		else:
			print("Speed reset")
			collisionCount = 0
			ballspeed = baseBallSpeed
			paddle_miss.emit()
			
		if (collisionCount > 0 && collisionCount % difficultyInterval == 0):
			ballspeed += ballSpeedIncrement
			print(ballspeed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	collisionCheck()
	
	var horizontalSpeed = delta * ballspeed
	if(!rightBound):
		horizontalSpeed *= -1
	
	me.position.x += horizontalSpeed
	me.position.z += verticalVelocity * delta * ballspeed
	
func _on_main_menu_game_reset() -> void:
	me.position = Vector3.ZERO
	ballspeed = 0

func _on_main_menu_game_resumed() -> void:
	ballspeed = pausedBallSpeed

func _on_main_menu_game_paused() -> void:
	pausedBallSpeed = ballspeed
	ballspeed = 0

func _on_main_menu_game_started() -> void:
	ballspeed = baseBallSpeed
