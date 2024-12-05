extends CanvasLayer

@export var gameTitle : String
@export var openMenuInput := "OpenMenu"

@onready var gameTitleLabel := $Panel/MarginContainer/VBoxContainer/GameTitle
@onready var startButton := $Panel/MarginContainer/VBoxContainer/StartButton
@onready var resumeButton := $Panel/MarginContainer/VBoxContainer/ResumeButton
@onready var resetButton := $Panel/MarginContainer/VBoxContainer/ResetButton
@onready var settingsButton := $Panel/MarginContainer/VBoxContainer/SettingsButton
@onready var quitButton := $Panel/MarginContainer/VBoxContainer/QuitButton

@onready var me := $"."

signal game_started
signal game_resumed
signal game_reset
signal game_paused

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gameTitleLabel.set_text(gameTitle)
	pass # Replace with function body.

func _input(event):
	if (event.is_action(openMenuInput) && event.is_pressed()):
		#game_paused.emit()
		set_visible(true)
		get_tree().paused = true

func _on_start_button_button_up() -> void:
	set_visible(false)
	startButton.set_disabled(true)
	resumeButton.set_disabled(false)
	game_started.emit()

func _on_resume_button_button_up() -> void:
	set_visible(false)
	game_resumed.emit()
	get_tree().paused = false

func _on_reset_button_button_up() -> void:
	startButton.set_disabled(false)
	resumeButton.set_disabled(true)
	game_reset.emit()

func _on_settings_button_button_up() -> void:
	print("IMPLEMENT SETTINGS MENU")

func _on_quit_button_button_up() -> void:
	get_tree().quit()
