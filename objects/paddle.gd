extends Node3D

enum direction {UP, DOWN, STATIONARY}
@onready var paddleObj = $PaddleObject
@onready var currentState := direction.STATIONARY

@export var paddleSpeed := 1
@export var bounds := 5.0
@export var paddleRadius = 1.0

@export var upInput := "MoveUp1"
@export var downInput := "MoveDown1"

@export var range := 5

var verticalMotion := 0.0

func getPaddlePos():
	return paddleObj.position
func _input(event):
	if event is InputEventMouseMotion:
		
		var windowsize = get_viewport().get_visible_rect().size
		verticalMotion = (-((event.position.x / windowsize.x) - 0.5) + (event.position.y / windowsize.y) - 0.5)
	#if event.is_action(upInput)  && event.is_pressed():
		#currentState = direction.UP
	#if event.is_action(downInput) && event.is_pressed():
		#currentState = direction.DOWN
		#
	#if event.is_action(upInput) && currentState == direction.UP  && event.is_released():
		#currentState = direction.STATIONARY
	#if event.is_action(downInput) && currentState == direction.DOWN && event.is_released():
		#currentState = direction.STATIONARY
		
	#if event is InputEventMouseMotion:
		#print("Mouse Velocity at: ", event.velocity)
		#verticalMotion += event.velocity.y

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var travelVec := Vector3.ZERO
	
	if currentState == direction.DOWN:
		travelVec.z = delta * paddleSpeed
	if currentState == direction.UP:
		travelVec.z = -delta * paddleSpeed
		
	paddleObj.position += travelVec
	
	var furthestDist = bounds - paddleRadius
	
	paddleObj.position.z = verticalMotion * bounds * 2.25
	
	paddleObj.position.z = min(paddleObj.position.z, furthestDist) 
	paddleObj.position.z = max(paddleObj.position.z, -furthestDist)
	
	
		
