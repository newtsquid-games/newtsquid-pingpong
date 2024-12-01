extends Node3D

enum direction {UP, DOWN, STATIONARY}

@onready var ball = $"../Ball"

@onready var paddleObj = $PaddleObject
@onready var currentState := direction.STATIONARY

@export var paddleSpeed := 1
@export var bounds := 5.0
@export var paddleRadius = 1.0

@export var upInput := "MoveUp1"
@export var downInput := "MoveDown1"

@export var range := 5

@export var ai := false


@onready var noise = FastNoiseLite.new()

var verticalMotion := 0.25

func getPaddlePos():
	return paddleObj.position
func _input(event):
	if ai:
		return
	if event is InputEventMouseMotion:
		
		var windowsize = get_viewport().get_visible_rect().size
		verticalMotion = (-((1.0-(event.position.x / windowsize.x)) - 0.5) + (event.position.y / windowsize.y) - 0.5)
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
func _physics_process(delta):
	
	var travelVec := Vector3.ZERO
	
	if currentState == direction.DOWN:
		travelVec.z = delta * paddleSpeed
	if currentState == direction.UP:
		travelVec.z = -delta * paddleSpeed
		
	if ai:
		var velocity = ball.getBallVelocity(.03)
		var incoming = (velocity.x > 0) != (paddleObj.position.x > 0)
		
		if incoming:
			#var wobble = cos( Time.get_unix_time_from_system() * 3.0) * 0.05
			var wobble = (noise.get_noise_2d(velocity.x, Time.get_ticks_usec() * 0.0001) - .05) * 0.2
			var wobble2 = (cos( Time.get_unix_time_from_system() * 2.1) * .15)
			var wobble3 = cos( Time.get_unix_time_from_system() * 4.0) + 1
			velocity.z += wobble2
			verticalMotion = lerpf(verticalMotion, ((ball.position.z + wobble) / bounds) + velocity.z, delta * 3 + wobble3 * delta)
			print(wobble)
		else:
			var randomPlace = (cos( Time.get_unix_time_from_system() * 2.1) * bounds)
			verticalMotion = lerpf(verticalMotion, randomPlace, delta * 0.1)
			
	
	
		
	paddleObj.position += travelVec
	
	var furthestDist = bounds - paddleRadius
	if ai:
		paddleObj.position.z = verticalMotion * bounds
	else:
		paddleObj.position.z = verticalMotion * bounds * 2.25
	
	paddleObj.position.z = min(paddleObj.position.z, furthestDist) 
	paddleObj.position.z = max(paddleObj.position.z, -furthestDist)
	
	
		
