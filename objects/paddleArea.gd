extends Area3D

enum DeflectionType {VERTICAL, HORIZONTAL, NONE}

@onready var paddleObject: CSGBox3D = $".."

func getDeflectionType() -> DeflectionType:
	return DeflectionType.HORIZONTAL

func getDeflectionVerticalVelocity(position: Vector3) -> float:
	return global_position.z - position.z
