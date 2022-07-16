extends Control

const CONFIGPATH := "user://polyarena.cfg"
const NAMES := [
	"mastermind",
	"muncher",
	"devioid",
	"observer",
	"hopper",
	"greeblin",
]

onready var _stat_menu = $StatMenu as Panel
onready var _options_menu = $OptionsMenu as Panel
onready var _stat_button = $VBoxContainer/StatButton as Button

var _config = ConfigFile.new()
var _music := AudioServer.get_bus_index("Music")
var _sfx := AudioServer.get_bus_index("SFX")

func _ready()->void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	_stat_button.grab_focus()
	_stat_menu.visible = false
	_options_menu.visible = false
	var err = _config.load(CONFIGPATH)
	if err != OK:
		print("could not load config")
		return
	_update_stats()
	$OptionsMenu/VBoxContainer2/Music.pressed = !AudioServer.is_bus_mute(_music)
	$OptionsMenu/VBoxContainer2/SFX.pressed = !AudioServer.is_bus_mute(_sfx)
	$OptionsMenu/VBoxContainer2/Fullscreen.pressed = OS.window_fullscreen


func _update_stats()->void:
	for name in NAMES:
		var label = $StatMenu.find_node(name.capitalize()) as Label
		label.text = name.capitalize() + ": " + str(_config.get_value("EnemiesKilled", name))
	$StatMenu/VBoxContainer8/BestTime.text = "Best Time: " + str(_config.get_value("Records", "best_time"))
	$StatMenu/VBoxContainer8/MostKills.text = "Most Kills: " + str(_config.get_value("Records", "most_kills"))


func _on_StatButton_pressed()->void:
	_stat_menu.visible = true
	$StatMenu/VBoxContainer7/BackButton.grab_focus()


func _on_BackButton_pressed()->void:
	_stat_menu.visible = false
	_options_menu.visible = false
	_stat_button.grab_focus()


func _on_ClearButton_pressed()->void:
	for name in NAMES:
		_config.set_value("EnemiesKilled", name, 0)
	_config.set_value("Records", "best_time", 0)
	_config.set_value("Records", "most_kills", 0)
	_config.save(CONFIGPATH)
	_update_stats()


func _on_PlayButton_pressed()->void:
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Main/Main.tscn")


func _on_Options_pressed()->void:
	_options_menu.visible = true
	$OptionsMenu/VBoxContainer2/Music.grab_focus()


func _on_Music_toggled(button_pressed:bool)->void:
	AudioServer.set_bus_mute(_music, !button_pressed)


func _on_SFX_toggled(button_pressed:bool)->void:
	AudioServer.set_bus_mute(_sfx, !button_pressed)


func _on_Fullscreen_toggled(button_pressed:bool)->void:
	OS.window_fullscreen = button_pressed
