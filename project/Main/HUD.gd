extends CanvasLayer

onready var _time_display = $Time as Label
onready var _kill_display = $Kills as Label
onready var _power_display = $ProgressBar as ProgressBar
onready var _health_animator = $AnimationPlayer as AnimationPlayer
onready var _game_over_display = $GameOverDisplay as Panel
onready var _click_sound = $Clicked as AudioStreamPlayer

var time := 0 setget _set_time
var percent_powered := 0.0 setget _set_power
var health := 6 setget _set_health
var kills := 0 setget _set_kills


func _ready()->void:
	# make sure the health die has six facing the camera
	_health_animator.play("RESET")
	_game_over_display.visible = false


func _set_time(value:int)->void:
	time = value
	_time_display.text = str(time)


func _set_power(value:float)->void:
	percent_powered = value
	_power_display.value = percent_powered * 100


func _set_health(value:int)->void:
	health = value
	if health >= 0:
		_health_animator.play(str(health))


func _set_kills(value:int)->void:
	kills = value
	_kill_display.text = str(kills)


func display_game_over(best_time:int, most_kills:int)->void:
	_game_over_display.visible = true
	$GameOverDisplay/VBoxContainer/Time.text = "Time: " + str(time)
	$GameOverDisplay/VBoxContainer/Kills.text = "Kills: " + str(kills)
	$GameOverDisplay/VBoxContainer/BestTime.text = "Best Time: " + str(best_time)
	$GameOverDisplay/VBoxContainer/MostKills.text = "Most Kills: " + str(most_kills)
	$GameOverDisplay/VBoxContainer/PlayAgain.grab_focus()


func _on_PlayAgain_pressed()->void:
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Main/Main.tscn")
	_click_sound.play()


func _on_MainMenu_pressed()->void:
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Menu/MainMenu.tscn")
	_click_sound.play()
