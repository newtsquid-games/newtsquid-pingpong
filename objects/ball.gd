extends Node3D
@export var paddleRadius := 2.0
@export var leftPaddle : Node3D
@export var rightPaddle : Node3D
@export var margin := 0.1
@export var bounds = 5.0

@export var hitVelocityDamping = 0.5

@export var ballspeed := 1.0

@export var upInput := "MoveUp1"
@export var downInput := "MoveDown1"
@export var resetBallInput := "ResetBall"

@onready var me := $"."

var rightBound := true
var verticalVelocity := 0.5

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
	
	if me.position.z < -bounds && verticalVelocity < 0:
		verticalVelocity *= -1
	
	if(me.position.x > bounds && me.position.x < bounds + margin):
		atLimit = true
	if(me.position.x < -bounds && me.position.x > -bounds - margin):
		atLimit = true
		
	if(atLimit):
		var left = leftPaddle.getPaddlePos()
		var right = rightPaddle.getPaddlePos()
		print(left, right)
		print(me.position)
		#run if collide
		if !rightBound && absf(left.z - me.position.z) < paddleRadius:
			verticalVelocity = lerp(-(left.z - me.position.z), verticalVelocity, hitVelocityDamping)
			rightBound = !rightBound
			print("bounce rightbound!")
		elif rightBound && absf(right.z - me.position.z) < paddleRadius:
			verticalVelocity = lerp(-(right.z - me.position.z), verticalVelocity, hitVelocityDamping)
			rightBound = !rightBound
			print("bounce leftbound!")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	collisionCheck()
	var horizontalSpeed = delta * ballspeed
	if(!rightBound):
		horizontalSpeed *= -1
	
	me.position.x += horizontalSpeed
	me.position.z += verticalVelocity * delta * ballspeed
	
	
