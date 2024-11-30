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
	
	if me.position.z > bounds - .15 && verticalVelocity > 0:
		verticalVelocity *= -1.0
	
	if me.position.z < -bounds + .15 && verticalVelocity < 0:
		verticalVelocity *= -1.0
	
	if(me.position.x > bounds && me.position.x < bounds + margin):
		atLimit = true
	if(me.position.x < -bounds && me.position.x > -bounds - margin):
		atLimit = true
		
	if(atLimit):
		var left = leftPaddle.getPaddlePos()
		var right = rightPaddle.getPaddlePos()
		print(left, right)
		print(me.position)
		
		var leftOffset = left.z - me.position.z
		var rightOffset = right.z - me.position.z
		#run if collide
		if me.position.x < 0 && !rightBound && absf(leftOffset) < paddleRadius:
			verticalVelocity = lerp(-(leftOffset * 1.5 * leftOffset * leftOffset), verticalVelocity, hitVelocityDamping)
			rightBound = true
			print("bounce rightbound!")
		elif me.position.x > 0 && rightBound && absf(rightOffset) < paddleRadius:
			verticalVelocity = lerp(-(rightOffset * 1.5 * rightOffset * rightOffset), verticalVelocity, hitVelocityDamping)
			rightBound = false
			print("bounce leftbound!")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	collisionCheck()
	var horizontalSpeed = 1.0
	if(!rightBound):
		horizontalSpeed *= -1.0
	
	#me.position.x += horizontalSpeed * delta  * ballspeed
	#me.position.z += verticalVelocity * delta * ballspeed
	
	me.position += Vector3(horizontalSpeed, 0, verticalVelocity).normalized() * delta * ballspeed
	
	
