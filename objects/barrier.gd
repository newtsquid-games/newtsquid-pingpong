extends Area3D

enum DeflectionType {VERTICAL, HORIZONTAL, NONE}

@export var deflectionType:DeflectionType
@export var xAxisLength:float
@export var yAxisLength:float
@export var zAxisLength:float

@onready var collisionShape:CollisionShape3D = %BarrierShape

signal barrier_crossed

func _ready() -> void:
	var shape = BoxShape3D.new()
	shape.size = Vector3(xAxisLength, yAxisLength, zAxisLength)
	collisionShape.set_shape(shape)
		
func getDeflectionType() -> DeflectionType:
	if (deflectionType == DeflectionType.NONE):
		barrier_crossed.emit()
	
	return deflectionType
