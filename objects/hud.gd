extends Control

@onready var score := 0
@onready var totalScoreLabel := $RootScoreContainer/TotalScoreContainer/ScoreDataContainer/ScoreContainer/ScoreValue
@onready var collisionScoreLabel := $RootScoreContainer/CollisionScoreContainer/ScoreDataContainer/ScoreContainer/ScoreValue
@onready var multiplierLabel := $RootScoreContainer/CollisionScoreContainer/ScoreDataContainer/MultiplierContainer/MultiplierValue
@onready var incrementLabel := $RootScoreContainer/TotalScoreContainer/ScoreDataContainer/IncrementValue

@export var collisionValue := 25
@export var scoreMulti := 1
@export var multiIncreaseInterval := 5

@export var incrementDisplayTimeout := 1
@onready var incrementDisplayTimer := Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	totalScoreLabel.text = str(score)
	collisionScoreLabel.text = str(score)
	multiplierLabel.text = str(scoreMulti)

func addScore(scoreValue: int):
	var scoreIncrement = scoreValue * scoreMulti
	
	collisionScoreLabel.text = str(scoreValue)
	multiplierLabel.text = str(scoreMulti)
	incrementLabel.text = "+" + str(scoreIncrement)
	
	score += scoreIncrement
	totalScoreLabel.text = str(score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_ball_paddle_collision(collision_count) -> void:
	if (collision_count % multiIncreaseInterval == 0):
		scoreMulti += 1

	addScore(collisionValue)


func _on_ball_paddle_miss() -> void:
	scoreMulti = 1
	
	addScore(0)
