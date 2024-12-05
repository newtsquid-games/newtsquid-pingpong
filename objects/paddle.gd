extends CSGBox3D

enum direction {UP, DOWN, STATIONARY}

@onready var currentState := direction.STATIONARY

@export var paddleSpeed := 1
@export var bounds := 5.0
@export var paddleRadius = 1.0
@export var paddleColor:Color

@export var upInput := "MoveUp1"
@export var downInput := "MoveDown1"
@export var range := 5

signal paddle_collision

func getPaddlePos():
	return position
	
func _input(event):
	if event.is_action(upInput) && event.is_pressed():
		currentState = direction.UP
	if event.is_action(downInput) && event.is_pressed():
		currentState = direction.DOWN
		
	if event.is_action(upInput) && currentState == direction.UP  && event.is_released():
		currentState = direction.STATIONARY
	if event.is_action(downInput) && currentState == direction.DOWN && event.is_released():
		currentState = direction.STATIONARY

# Called when the node enters the scene tree for the first time.
func _ready():
	var newMaterial = StandardMaterial3D.new()
	newMaterial.albedo_color = paddleColor
	material = newMaterial


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var travelVec := Vector3.ZERO
	
	if currentState == direction.DOWN:
		travelVec.z = delta * paddleSpeed
	if currentState == direction.UP:
		travelVec.z = -delta * paddleSpeed
		
	position += travelVec
	
	var furthestDist = bounds
	
	position.z = min(position.z, furthestDist)
	position.z = max(position.z, -furthestDist)

func _on_paddle_area_area_entered(area: Area3D) -> void:
	paddle_collision.emit()
