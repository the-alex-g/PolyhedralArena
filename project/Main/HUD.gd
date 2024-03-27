extends CanvasLayer

@onready var _score_display = $Score as Label
@onready var _power_display = $ProgressBar as ProgressBar
@onready var _health_animator = $AnimationPlayer as AnimationPlayer
@onready var _game_over_display : PanelContainer = $GameOverDisplay

var score := 0 : set = _set_score
var percent_powered := 0.0: set = _set_power
var health := 6: set = _set_health


func _ready()->void:
	# make sure the health die has six facing the camera
	_health_animator.play("RESET")
	_game_over_display.visible = false


func _set_score(value:int)->void:
	score = value
	_score_display.text = str(score)


func _set_power(value:float)->void:
	percent_powered = value
	_power_display.value = percent_powered * 100


func _set_health(value:int)->void:
	health = value
	if health >= 0:
		_health_animator.play(str(health))



func display_game_over(best_score:int)->void:
	_game_over_display.visible = true
	$GameOverDisplay/VBoxContainer/Score.text = "Score: " + str(score)
	$GameOverDisplay/VBoxContainer/BestScore.text = "Best Score: " + str(best_score)
	$GameOverDisplay/VBoxContainer/PlayAgain.grab_focus()


func _on_PlayAgain_pressed()->void:
	# warning-ignore:return_value_discarded
	get_tree().change_scene_to_file("res://Main/Main.tscn")


func _on_MainMenu_pressed()->void:
	# warning-ignore:return_value_discarded
	get_tree().change_scene_to_file("res://Menu/MainMenu.tscn")
